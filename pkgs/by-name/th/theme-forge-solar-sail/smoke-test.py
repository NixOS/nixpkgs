"""Exercise the installed Solar Sail compiler without network or user files."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile

prefix = Path(sys.argv[1])
cli = prefix / "bin/tfss"
package = prefix / "lib/node_modules/@knowledge-forge-ai/theme-forge-solar-sail"
fixture = package / "examples/forge-console.theme.json"


def run(*args, expected=0):
    p = subprocess.run([str(cli), *map(str, args)], input="", text=True,
                       capture_output=True, timeout=60)
    assert p.returncode == expected, (p.returncode, p.stdout, p.stderr)
    return p.stdout


manifest = json.loads((package / "package.json").read_text())
assert not manifest.get("dependencies") and not manifest.get("optionalDependencies")
assert "0.1.0" in run("--version")
assert "compile" in run("--help")
with tempfile.TemporaryDirectory() as td:
    work = Path(td)
    result = json.loads(run("validate", fixture, "--json"))
    assert result["status"] == "success" and result["valid"] is True
    results = []
    for name in ("first", "second"):
        dest = work / name
        result = json.loads(run("compile", fixture, "--out", dest, "--json"))
        css = (dest / "theme.css").read_bytes()
        assert b"@theme inline" in css
        assert b"--color-background:" in css and b"--color-primary:" in css
        assert hashlib.sha256(css).hexdigest() == result["outputDigest"]
        results.append(css)
    assert results[0] == results[1], "Compilation was not deterministic"
    bad = work / "invalid.json"
    bad.write_text('{}\n')
    result = json.loads(run("validate", bad, "--json", expected=1))
    assert result["valid"] is False and result["errors"]
print("Solar Sail: version, help, validation, deterministic CSS, negative input passed")
