#!/usr/bin/env python3
"""Check the local patch against actual pinned LLVM source and matching headers.

Requires an already installed LLVM from this revision for generated headers and
libLLVMSupport. It does not realize or rebuild LLVM. The unit-test translation
units are compiled, not linked into a replacement LLVM test suite.
"""

import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--source-root", required=True, type=Path)
parser.add_argument("--installed-llvm", required=True, type=Path)
parser.add_argument("--cxx", required=True)
parser.add_argument("--output", required=True, type=Path)
parser.add_argument("--unpatched", action="store_true")
args = parser.parse_args()
args.output.mkdir(parents=True, exist_ok=True)
fixture = Path(__file__).resolve()
patch = fixture.parent.parent / "initialize-caches-and-test-state.patch"
overlay = args.output / "source"
files = [
    "llvm/include/llvm/Object/SFrameParser.h",
    "llvm/include/llvm/ADT/iterator.h",
    "llvm/unittests/ADT/CountCopyAndMove.h",
    "llvm/unittests/ExecutionEngine/Orc/ResourceTrackerTest.cpp",
    "llvm/lib/Object/SFrameParser.cpp",
    "llvm/lib/Object/Error.cpp",
    "llvm/unittests/ADT/FunctionExtrasTest.cpp",
    "llvm/unittests/ADT/IteratorTest.cpp",
]
evidence = {"source_root": str(args.source_root),
            "installed_llvm": str(args.installed_llvm),
            "patch_sha256": hashlib.sha256(patch.read_bytes()).hexdigest(),
            "fixture_sha256": hashlib.sha256(fixture.with_suffix(".cpp").read_bytes()).hexdigest(),
            "unpatched": args.unpatched, "source_sha256": {}, "commands": []}
for relative in files:
    src, dest = args.source_root / relative, overlay / relative
    dest.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(src, dest)
    evidence["source_sha256"][relative] = hashlib.sha256(src.read_bytes()).hexdigest()

environment = dict(os.environ, LC_ALL="C")


def run(name, command, **kwargs):
    result = subprocess.run(command, env=environment, text=True,
                            capture_output=True, **kwargs)
    log = result.stdout + result.stderr
    (args.output / f"{name}.log").write_text(log)
    evidence["commands"].append({"name": name, "argv": command,
                                 "status": result.returncode,
                                 "uninitialized_warnings": log.count("[-Wuninitialized]")
                                 + log.count("[-Wmaybe-uninitialized]")})
    (args.output / "results.json").write_text(json.dumps(evidence, indent=2) + "\n")
    if result.returncode:
        raise SystemExit(f"{name} failed; see {args.output / (name + '.log')}")


if not args.unpatched:
    run("patch", ["patch", "-p1", "-i", str(patch)], cwd=overlay)

includes = [overlay / "llvm/include", args.installed_llvm / "include",
            overlay / "llvm/unittests/ADT", args.source_root / "llvm/unittests/ADT",
            args.source_root / "llvm/unittests/ExecutionEngine/Orc",
            args.source_root / "third-party/unittest/googletest/include",
            args.source_root / "third-party/unittest/googlemock/include"]
common = [args.cxx, "-std=c++17", "-O2", "-Wall", "-Wextra", "-Wuninitialized"]
has_rtti = subprocess.check_output(
    [str(args.installed_llvm / "bin/llvm-config"), "--has-rtti"],
    env=environment, text=True).strip()
if has_rtti == "NO":
    common += ["-fno-rtti"]
common += ["-I" + str(path) for path in includes]
for name, relative in (("sframe", "llvm/lib/Object/SFrameParser.cpp"),
                       ("object-error", "llvm/lib/Object/Error.cpp"),
                       ("resource-tracker", "llvm/unittests/ExecutionEngine/Orc/ResourceTrackerTest.cpp"),
                       ("function-extras", "llvm/unittests/ADT/FunctionExtrasTest.cpp"),
                       ("iterator", "llvm/unittests/ADT/IteratorTest.cpp")):
    source = overlay / relative if relative in files else args.source_root / relative
    run(name, [*common, "-DNDEBUG", "-c", str(source), "-o", str(args.output / f"{name}.o")])

executable = args.output / "initialization"
run("compile-runtime", [*common, str(fixture.with_suffix(".cpp")),
                        str(args.output / "sframe.o"),
                        str(args.output / "object-error.o"),
                        "-L" + str(args.installed_llvm / "lib"),
                        "-Wl,-rpath," + str(args.installed_llvm / "lib"),
                        "-lLLVMSupport", "-o", str(executable)])
run("runtime", [str(executable)])
print(json.dumps(evidence, indent=2))
