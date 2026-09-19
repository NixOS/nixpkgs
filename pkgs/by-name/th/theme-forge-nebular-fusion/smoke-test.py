"""Headless bundle/runtime test. This deliberately does not claim GUI launch."""
import hashlib
import json
import os
from pathlib import Path
import plistlib
import struct
import subprocess
import sys
import tarfile

prefix = Path(sys.argv[1])
cli = prefix / "bin/tfnf"
app = prefix / "Applications/Theme Forge Nebular Fusion.app"


def run(exe, *args):
    p = subprocess.run([str(exe), *map(str, args)], input="", text=True,
                       capture_output=True, timeout=60)
    assert p.returncode == 0, (p.returncode, p.stdout, p.stderr)
    return p.stdout


assert "0.4.0" in run(cli, "--version")
assert "launcher" in run(cli, "--help")
assert Path(run(cli, "--path").strip()) == app
with (app / "Contents/Info.plist").open("rb") as stream:
    info = plistlib.load(stream)
assert info["CFBundleShortVersionString"] == "0.4.0"
exe = app / "Contents/MacOS" / info["CFBundleExecutable"]
with exe.open("rb") as stream:
    magic, cpu = struct.unpack("<II", stream.read(8))
assert magic == 0xFEEDFACF and cpu == 0x0100000C, "Expected arm64 Mach-O"
resources = app / "Contents/Resources"
node = app / "Contents/MacOS/tfsb-studio-service"
assert run(node, "--version").strip().startswith("v22.")
addon = resources / "sidecar-payload/native/directory-snapshot/prebuilds/darwin-arm64/native-addon-posix-openat-v1.node"
run(node, "-e", "const m=require(process.argv[1]); if(m.abiVersion!==1 || typeof m.openFilesystemRoot!==\"function\") process.exit(1)", addon)
# Exercise the bundled theme compilers with their own runtime, not system Node.
for product, fixture, module, fn in (
    ("loom-payload", "amber-forge.theme.json", "compiler/index.js", "compileTheme"),
    ("solar-sail-payload", None, "index.js", None),
):
    entry = resources / product / "dist" / module
    if fixture:
        script = '''import {readFileSync} from "node:fs";
import {pathToFileURL} from "node:url";
const mod=await import(pathToFileURL(process.argv[1]).href);
const result=mod.compileTheme(JSON.parse(readFileSync(process.argv[2],"utf8")));
if(!result.css.includes("--sl-color-accent:")) process.exit(1);'''
        run(node, "--input-type=module", "-e", script, entry,
            resources / product / "examples" / fixture)
    else:
        script = '''import {pathToFileURL} from "node:url";
const mod=await import(pathToFileURL(process.argv[1]).href);
if(typeof mod.compileTheme !== "function") process.exit(1);'''
        run(node, "--input-type=module", "-e", script, entry)
print(json.dumps({"bundle": "pass", "bundled_node": "pass", "native_addon": "pass",
                  "bundled_loom_compile": "pass", "solar_module": "pass", "gui": "not-tested"}))

expected_paths = set()
with tarfile.open(sys.argv[2], "r:gz") as archive:
    for member in archive.getmembers():
        parts = Path(member.name).parts
        if not parts or parts[0] != app.name:
            continue
        rel = Path(*parts[1:])
        dest = app / rel
        if member.isdir():
            assert dest.is_dir(), str(rel)
            continue
        expected_paths.add(rel.as_posix())
        if member.issym():
            assert dest.is_symlink() and os.readlink(dest) == member.linkname, str(rel)
        elif member.isfile():
            stream = archive.extractfile(member)
            assert stream is not None and dest.is_file() and not dest.is_symlink(), str(rel)
            expected = hashlib.file_digest(stream, "sha256").hexdigest()
            with dest.open("rb") as local:
                actual = hashlib.file_digest(local, "sha256").hexdigest()
            assert actual == expected, f"Bundle file changed: {rel}"
            assert (dest.stat().st_mode & 0o111) == (member.mode & 0o111), str(rel)
        else:
            raise AssertionError(f"Unexpected archive member type: {member.name}")
actual_paths = {p.relative_to(app).as_posix() for p in app.rglob("*")
                if p.is_symlink() or p.is_file()}
assert expected_paths == actual_paths, "Installed bundle membership differs from release"
print("Nebular: every application file/link and executable bit matches the pinned release")
