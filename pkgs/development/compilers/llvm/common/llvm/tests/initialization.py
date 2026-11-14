#!/usr/bin/env python3
"""Compile the shared initialization repairs against matching installed LLVM.

The source root is an unpatched llvm-project checkout. LLVM 18 lacks the Count
helper and LLVM before 22 lacks SFrame; their absent checks are recorded. This
compiles selected unit-test translation units, not the complete LLVM test suite.
The compiler and llvm-config must execute on this machine, and their outputs
must also target this machine.
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
parser.add_argument("--llvm-config", required=True, type=Path)
parser.add_argument("--cxx", required=True)
parser.add_argument("--output", required=True, type=Path)
parser.add_argument("--unpatched", action="store_true")
args = parser.parse_args()
args.output = args.output.resolve()
args.source_root = args.source_root.resolve()
args.output.mkdir(parents=True, exist_ok=True)
fixture = Path(__file__).resolve()
overlay = args.output / "source"
environment = dict(os.environ, LC_ALL="C")


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


count = args.source_root / "llvm/unittests/ADT/CountCopyAndMove.h"
sframe = args.source_root / "llvm/include/llvm/Object/SFrameParser.h"
features = {"count_copy_and_move": count.exists(), "sframe": sframe.exists(),
            "construction_counters": count.exists() and "DefaultConstructions" in count.read_text()}
patches = [fixture.parent.parent / "initialize-iterator-and-resource-state.patch"]
if features["count_copy_and_move"]:
    patches.append(fixture.parent.parent / "initialize-count-copy-and-move.patch")
if features["sframe"]:
    patches.append(fixture.parent.parent / "initialize-sframe-cache.patch")
files = ["llvm/include/llvm/ADT/iterator.h",
         "llvm/unittests/ExecutionEngine/Orc/ResourceTrackerTest.cpp",
         "llvm/unittests/ADT/FunctionExtrasTest.cpp",
         "llvm/unittests/ADT/IteratorTest.cpp"]
if features["count_copy_and_move"]:
    files.append("llvm/unittests/ADT/CountCopyAndMove.h")
if features["sframe"]:
    files += ["llvm/include/llvm/Object/SFrameParser.h",
              "llvm/lib/Object/SFrameParser.cpp", "llvm/lib/Object/Error.cpp"]
evidence = {"source_root": str(args.source_root), "llvm_config": str(args.llvm_config),
            "patches": {p.name: digest(p) for p in patches},
            "fixture_sha256": digest(fixture.with_suffix(".cpp")),
            "runner_sha256": digest(fixture), "features": features,
            "unpatched": args.unpatched, "source_sha256": {}, "commands": []}
for relative in files:
    src, dest = args.source_root / relative, overlay / relative
    dest.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(src, dest)
    evidence["source_sha256"][relative] = digest(src)


def run(name, command, **kwargs):
    command = [str(arg) for arg in command]
    result = subprocess.run(command, env=environment, text=True,
                            errors="backslashreplace", capture_output=True, **kwargs)
    log = result.stdout + result.stderr
    (args.output / f"{name}.log").write_text(log)
    evidence["commands"].append({"name": name, "argv": command,
                                 "status": result.returncode,
                                 "uninitialized_warnings": log.count("[-Wuninitialized]")
                                 + log.count("[-Wmaybe-uninitialized]")})
    (args.output / "results.json").write_text(json.dumps(evidence, indent=2) + "\n")
    if result.returncode:
        raise SystemExit(f"{name} failed; see {args.output / (name + '.log')}")
    return result.stdout.strip()


if not args.unpatched:
    for patch in patches:
        run(patch.stem, ["patch", "--fuzz=0", "-p1", "-i", patch], cwd=overlay / "llvm")

# llvm-config resolves split dev/lib outputs as well as Triton's single output.
include_dir = run("includedir", [args.llvm_config, "--includedir"])
lib_dir = run("libdir", [args.llvm_config, "--libdir"])
has_rtti = run("has-rtti", [args.llvm_config, "--has-rtti"])
includes = [overlay / "llvm/include", Path(include_dir),
            overlay / "llvm/unittests/ADT", args.source_root / "llvm/unittests/ADT",
            args.source_root / "llvm/unittests/ExecutionEngine/Orc",
            args.source_root / "third-party/unittest/googletest/include",
            args.source_root / "third-party/unittest/googlemock/include"]
common = [args.cxx, "-std=c++17", "-O2", "-Wall", "-Wextra", "-Wuninitialized"]
if has_rtti == "NO":
    common += ["-fno-rtti"]
common += ["-I" + str(path) for path in includes]
for name, enabled in features.items():
    common.append(f"-DHAVE_{name.upper()}={int(enabled)}")
units = [("resource-tracker", "llvm/unittests/ExecutionEngine/Orc/ResourceTrackerTest.cpp"),
         ("function-extras", "llvm/unittests/ADT/FunctionExtrasTest.cpp"),
         ("iterator", "llvm/unittests/ADT/IteratorTest.cpp")]
if features["sframe"]:
    units += [("sframe", "llvm/lib/Object/SFrameParser.cpp"),
              ("object-error", "llvm/lib/Object/Error.cpp")]
for name, relative in units:
    run(name, [*common, "-DNDEBUG", "-c", overlay / relative,
               "-o", args.output / f"{name}.o"])

executable = args.output / "initialization"
link = []
if features["sframe"]:
    link += [args.output / "sframe.o", args.output / "object-error.o"]
link += ["-L" + lib_dir, "-Wl,-rpath," + lib_dir, "-lLLVMSupport"]
run("compile-runtime", [*common, fixture.with_suffix(".cpp"), *link, "-o", executable])
run("runtime", [executable])
print(json.dumps(evidence, indent=2))
