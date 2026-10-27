"""Audit the selected installed output without a Nix daemon or GPU access."""

import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def command(*args):
    result = subprocess.run(
        args, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, check=False
    )
    require(
        result.returncode == 0, f"{args}: exit {result.returncode}\n{result.stdout}"
    )
    return result.stdout


def main():
    config = json.loads(Path(sys.argv[1]).read_text())
    require(len(sys.argv) <= 3, "Usage: xla-install [LOG_DIRECTORY]")
    logs = Path(
        sys.argv[2] if len(sys.argv) == 3 else tempfile.mkdtemp(prefix="xla-install-")
    )
    logs.mkdir(parents=True, exist_ok=True)
    package = Path(config["package"])
    cuda = config["cudaSupport"]
    cuda_tool_root = Path(config["cudaToolRoot"]) if cuda else None
    cuda_root_needle = str(cuda_tool_root).encode() if cuda else None
    cuda_root_reference = False
    # Do not let a caller's search path hide broken installed RUNPATHs.
    os.environ.pop("LD_LIBRARY_PATH", None)
    os.environ.pop("LD_PRELOAD", None)
    dynamic_count = 0
    allowed_driver_count = 0
    with (logs / "elf.log").open("w") as log:
        for path in sorted(package.rglob("*")):
            require(
                not path.name.endswith(".runfiles_manifest"), f"stale manifest: {path}"
            )
            if path.is_symlink():
                require(
                    "/build/output" not in os.readlink(path), f"stale symlink: {path}"
                )
                continue
            if not path.is_file():
                continue
            # Stream large archives, retaining enough overlap to find split matches.
            with path.open("rb") as file:
                magic = file.read(4)
                file.seek(0)
                tail = b""
                while chunk := file.read(1024 * 1024):
                    window = tail + chunk
                    require(
                        b"/build/output" not in window,
                        f"stale build path: {path}",
                    )
                    if cuda and cuda_root_needle in window:
                        cuda_root_reference = True
                    tail = chunk[-max(12, len(cuda_root_needle or b"")) :]
            if magic != b"\x7fELF":
                continue
            dynamic = command("readelf", "-d", str(path))
            if "(NEEDED)" not in dynamic:
                # Relocatable objects/static executables have no dynamic dependencies.
                continue
            dynamic_count += 1
            linkage = command("ldd", str(path))
            log.write(f"{path}\n{linkage}\n")
            for line in linkage.splitlines():
                if "not found" in line:
                    require(
                        cuda
                        and re.fullmatch(r"\s*libcuda\.so\.1 => not found\s*", line),
                        f"unresolved dependency: {path}: {line}",
                    )
                    allowed_driver_count += 1
    require(dynamic_count > 0, "no dynamic ELF files audited")

    for platform in ["cpu"] + (["gpu"] if cuda else []):
        plugin = package / "lib" / f"pjrt_c_api_{platform}_plugin.so"
        symbols = command("nm", "-D", "--defined-only", str(plugin))
        require(
            any(
                line.split()[-1].split("@", 1)[0] == "GetPjrtApi"
                for line in symbols.splitlines()
                if line.split()
            ),
            f"missing GetPjrtApi export: {plugin}",
        )
    if cuda:
        require(
            cuda_root_reference,
            f"installed files do not reference packaged CUDA tools: {cuda_tool_root}",
        )
        for relative in config["cudaToolArtifacts"]:
            artifact = cuda_tool_root / relative
            require(artifact.is_file(), f"missing packaged CUDA tool: {artifact}")
            if relative.startswith("bin/"):
                require(
                    os.access(artifact, os.X_OK),
                    f"CUDA tool is not executable: {artifact}",
                )
        runpaths = command("patchelf", "--print-rpath", str(plugin)).strip().split(":")
        for expected in [config["driverRunpath"], *config["pluginRunpaths"]]:
            require(expected in runpaths, f"missing GPU RUNPATH: {expected}")
        for name, version, soname in [
            ("libnvshmem_host", "3.2.5", "3"),
            ("nvshmem_bootstrap_uid", "3.0.0", "3"),
            ("nvshmem_transport_ibrc", "3.0.0", "3"),
        ]:
            library = package / "lib" / f"{name}.so.{version}"
            link = package / "lib" / f"{name}.so.{soname}"
            require(library.is_file(), f"missing NVSHMEM runtime: {library}")
            require(
                link.is_symlink() and link.resolve() == library,
                f"wrong SONAME link: {link}",
            )
            require(
                command("patchelf", "--print-soname", str(library)).strip()
                == link.name,
                f"wrong SONAME: {library}",
            )
        # autoPatchelf's runtimeDependencies apply to the executable. In
        # particular, rdma-core here does NOT establish IBRC dlopen resolution.
        cli_runpaths = (
            command("patchelf", "--print-rpath", str(package / "bin/run_hlo_module"))
            .strip()
            .split(":")
        )
        for expected in config["runtimeRunpaths"]:
            require(
                expected in cli_runpaths, f"missing CLI runtime RUNPATH: {expected}"
            )

    closure_text = Path(config["closure"]).read_text()
    (logs / "closure.txt").write_text(closure_text)
    closure = set(closure_text.splitlines())
    if cuda:
        require(
            str(cuda_tool_root) in closure,
            f"packaged CUDA tools absent from closure: {cuda_tool_root}",
        )
        for runpath in config["runtimeRunpaths"]:
            require(
                str(Path(runpath).parent) in closure,
                f"declared runtime absent from closure: {runpath}",
            )
    for forbidden in config["forbiddenPaths"]:
        require(
            forbidden not in closure,
            f"build-only input in runtime closure: {forbidden}",
        )
    if not cuda:
        # Package-name predicate is deliberately explicit; do not ban generic
        # compiler runtime libraries or compare historical closure/file counts.
        cuda_name = re.compile(
            r"(?:cuda[0-9.-]*-|cudnn-|libcu(?:blas|fft|rand|solver|sparse)-|nccl-|nvshmem-)"
        )
        for store_path in closure:
            name = Path(store_path).name.split("-", 1)[1]
            require(
                not cuda_name.match(name), f"CUDA runtime in CPU closure: {store_path}"
            )
    summary = f"PASS: install audit; dynamic ELF files={dynamic_count}, allowed host-driver misses={allowed_driver_count}\n"
    (logs / "summary.log").write_text(summary)
    print(summary, end="")


if __name__ == "__main__":
    try:
        main()
    except (RuntimeError, OSError) as error:
        sys.exit(f"FAIL: {error}")
