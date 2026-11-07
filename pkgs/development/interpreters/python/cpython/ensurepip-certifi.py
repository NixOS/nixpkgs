"""Append ../pip-certifi-override.py to the vendored certifi in pip wheels.

The wheel is rewritten in place, keeping entry order and timestamps.
Usage: ensurepip-certifi.py OVERRIDE WHEEL...
"""

import base64
import hashlib
import sys
import zipfile

CORE = "pip/_vendor/certifi/core.py"


def record_hash(data):
    digest = hashlib.sha256(data).digest()
    return "sha256=" + base64.urlsafe_b64encode(digest).rstrip(b"=").decode()


def patch(wheel, override):
    with zipfile.ZipFile(wheel) as zin:
        infos = zin.infolist()
        names = [i.filename for i in infos]
        if CORE not in names:
            return
        data = {i.filename: zin.read(i) for i in infos}

    data[CORE] += b"\n\n" + override

    record = next(n for n in names if n.endswith(".dist-info/RECORD"))
    lines = []
    for line in data[record].decode().splitlines():
        path = line.split(",", 1)[0]
        if path == CORE:
            line = "%s,%s,%d" % (CORE, record_hash(data[CORE]), len(data[CORE]))
        lines.append(line)
    data[record] = ("\n".join(lines) + "\n").encode()

    with zipfile.ZipFile(wheel, "w") as zout:
        for info in infos:
            zout.writestr(info, data[info.filename])
    print("patched", wheel)


with open(sys.argv[1], "rb") as f:
    override = f.read()

for wheel in sys.argv[2:]:
    patch(wheel, override)
