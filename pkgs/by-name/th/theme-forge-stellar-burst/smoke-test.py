"""Build an original SVG fixture twice and reject malformed input."""
from pathlib import Path
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET

prefix = Path(sys.argv[1])
cli = prefix / "bin/tfsb"


def run(*args, expected=0):
    p = subprocess.run([str(cli), *map(str, args)], input="", text=True,
                       capture_output=True, timeout=60)
    assert p.returncode == expected, (p.returncode, p.stdout, p.stderr)
    return p


assert "0.5.0" in run("--version").stdout
assert "build" in run("--help").stdout
assert (prefix / "bin/tfsb-studio-service").is_file()
with tempfile.TemporaryDirectory() as td:
    root = Path(td)
    assets = root / ".tfsb/assets"
    assets.mkdir(parents=True)
    (root / ".tfsb/project.toml").write_text(
        'schema_version = 1\nname = "Nixpkgs smoke test"\n'
        '[build]\ndirectory = "generated"\n')
    fixture = assets / "check.toml"
    fixture.write_text('''schema_version = 1
id = "check"
filename = "check.svg"
[canvas]
width = 24
height = 24
view_box = "0 0 24 24"
[accessibility]
title = "Packaging smoke test"
title_id = "check-title"
description = "An original square fixture for the Nix packaging test."
description_id = "check-description"
[[elements]]
type = "path"
id = "box"
fill = "#336699"
d = "M2 2 H22 V22 H2 Z"
''')
    run("build", "--root", root)
    output = root / "generated/check.svg"
    first = output.read_bytes()
    svg = ET.fromstring(first)
    ns = "{http://www.w3.org/2000/svg}"
    assert svg.tag == ns + "svg" and svg.attrib["viewBox"] == "0 0 24 24"
    assert svg.find(ns + "path").attrib["fill"] == "#336699"
    run("build", "--root", root)
    assert output.read_bytes() == first, "Compilation was not deterministic"
    fixture.write_text('schema_version = 1\nid = "check"\n')
    failure = run("build", "--root", root, expected=1)
    assert "SCHEMA_" in failure.stderr
    assert output.read_bytes() == first, "Invalid input changed prior output"
print("Burst: version, help, deterministic SVG, rejected input and output preservation passed")

# Check the runtime native-addon path that the SVG-only test does not exercise.
module = prefix / "lib/node_modules/@knowledge-forge-ai/theme-forge-stellar-burst/dist/directory-snapshot-native.js"
probe = """import {pathToFileURL} from 'node:url';
const mod = await import(pathToFileURL(process.argv[1]).href);
const result = mod.loadDirectorySnapshotNative();
if (!result.ok) throw new Error(JSON.stringify(result));"""
p = subprocess.run([sys.argv[2], "--input-type=module", "-e", probe, str(module)],
                   input="", text=True, capture_output=True, timeout=60)
assert p.returncode == 0, (p.stdout, p.stderr)
print("Burst: installed native-addon load and self-test passed")
