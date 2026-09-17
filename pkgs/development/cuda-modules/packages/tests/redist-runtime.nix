{
  cuda_nvrtc,
  cudaNamePrefix,
  lib,
  patchelf,
  python3,
  stdenvNoCC,
}:
let
  # The BUILD variant can have HOST != TARGET, just like NVCC used to cross
  # compile. Its packaged ELF files still need the runtime for its HOST.
  cases =
    lib.mapAttrsToList
      (
        role: package:
        let
          runtime = lib.head package.buildInputs;
          host = package.stdenv.hostPlatform;
        in
        assert runtime.isGNU;
        assert runtime.stdenv.targetPlatform == host;
        {
          inherit role;
          runtime = toString runtime;
          library = toString (lib.getLib package);
          machine =
            {
              x86_64 = 62;
              aarch64 = 183;
              powerpc64le = 21;
            }
            .${host.parsed.cpu.name};
        }
      )
      {
        host = cuda_nvrtc;
        build = cuda_nvrtc.__spliced.buildHost or cuda_nvrtc;
      };
in
stdenvNoCC.mkDerivation {
  name = "${cudaNamePrefix}-tests-redist-runtime";
  strictDeps = true;
  nativeBuildInputs = [
    patchelf
    python3
  ];
  passAsFile = [ "cases" ];
  cases = builtins.toJSON cases;
  buildCommand = ''
    python3 - "$casesPath" "$out" <<'PY'
    import json
    from pathlib import Path
    import struct
    import subprocess
    import sys

    def machine(path):
        with path.open("rb") as stream:
            header = stream.read(20)
        if header[:4] != b"\x7fELF":
            return None
        return struct.unpack("<H" if header[5] == 1 else ">H", header[18:20])[0]

    reports = []
    for case in json.loads(Path(sys.argv[1]).read_text()):
        runtime = Path(case["runtime"]) / "lib"
        for name in ("libstdc++.so.6", "libgcc_s.so.1"):
            assert machine(runtime / name) == case["machine"], (case, name)
        elfs = []
        for path in sorted((Path(case["library"]) / "lib").glob("*.so*")):
            if not path.is_file() or path.is_symlink():
                continue
            assert machine(path) == case["machine"], (case, path)
            needed = subprocess.check_output(["patchelf", "--print-needed", path], text=True).splitlines()
            rpath = subprocess.check_output(["patchelf", "--print-rpath", path], text=True).strip()
            directories = [Path(entry.replace("$ORIGIN", str(path.parent))) for entry in rpath.split(":") if entry]
            for name in ("libstdc++.so.6", "libgcc_s.so.1"):
                if name in needed:
                    resolved = next((directory / name for directory in directories if (directory / name).is_file()), None)
                    assert resolved and resolved.resolve() == (runtime / name).resolve(), (case, path, name, rpath)
            elfs.append({"path": str(path), "needed": needed, "rpath": rpath})
        assert elfs, case
        reports.append(dict(case, elfs=elfs))
    Path(sys.argv[2]).write_text(json.dumps(reports, indent=2) + "\n")
    PY
  '';
}
