import base64
import binascii
import configparser
import json
import pathlib
import sys
import urllib.parse


def to_sri(hash: str):
    raw = binascii.unhexlify(hash)
    b64 = base64.b64encode(raw).decode()
    return f"sha256-{b64}"


def main(dir: str):
    result = []
    for file in (pathlib.Path(dir) / "subprojects").glob("*.wrap"):
        name = file.stem
        parser = configparser.ConfigParser()
        _ = parser.read(file)
        sections = parser.sections()
        if "wrap-file" not in sections:
            continue

        url = parser.get("wrap-file", "source_url")
        if "crates.io" not in url:
            continue

        parsed = urllib.parse.urlparse(url)
        path = parsed.path.split("/")
        assert path[4] == name
        version = path[5]

        hash = to_sri(parser.get("wrap-file", "source_hash"))

        result.append({
            "pname": name,
            "version": version,
            "hash": hash,
        })

    here = pathlib.Path(__file__).parent
    with (here / "wraps.json").open("w") as fd:
        json.dump(result, fd, indent=4)
        _ = fd.write("\n")


if __name__ == '__main__':
    main(*sys.argv[1:])
