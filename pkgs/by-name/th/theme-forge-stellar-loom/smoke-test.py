"""Exercise the installed Loom CLI and EOF-delimited batch interface offline."""
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile

prefix = Path(sys.argv[1])
cli = prefix / "bin/tfsl"
batch = prefix / "bin/tfsl-batch"
package = prefix / "lib/node_modules/@knowledge-forge-ai/theme-forge-stellar-loom"
fixture = package / "examples/amber-forge.theme.json"


def run(executable, *args, data=None, expected=0):
    p = subprocess.run([str(executable), *map(str, args)], input=data or "",
                       text=True, capture_output=True, timeout=60)
    assert p.returncode == expected, (p.returncode, p.stdout, p.stderr)
    return p.stdout


manifest = json.loads((package / "package.json").read_text())
assert not manifest.get("dependencies") and not manifest.get("optionalDependencies")
assert "0.3.0" in run(cli, "--version")
assert "compile" in run(cli, "--help")
with tempfile.TemporaryDirectory() as td:
    work = Path(td)
    assert json.loads(run(cli, "validate", fixture, "--json"))["status"] == "success"
    results = []
    for name in ("first", "second"):
        dest = work / name
        status = json.loads(run(cli, "compile", fixture, "--out", dest, "--json"))
        css = (dest / "theme.css").read_bytes()
        assert b"--sl-color-accent:" in css
        assert hashlib.sha256(css).hexdigest() == status["outputDigest"]
        assert isinstance(json.loads((dest / "theme.descriptor.json").read_text()), dict)
        results.append(css)
    assert results[0] == results[1], "Compilation was not deterministic"
    request = {"action": "compile", "uiRevision": 7,
               "specification": json.loads(fixture.read_text())}
    result = json.loads(run(batch, data=json.dumps(request)))
    assert result["status"] == "success" and result["valid"] is True
    assert result["uiRevision"] == 7
    assert result["compiledCss"].encode() == results[0]
    bad = work / "invalid.json"
    bad.write_text('{}\n')
    assert json.loads(run(cli, "validate", bad, "--json", expected=1))["status"] == "error"
print("Loom: version, help, validation, deterministic CSS, batch protocol, negative input passed")
