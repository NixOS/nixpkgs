#!/usr/bin/env nix-shell
#! nix-shell -i "python3 -I" -p python3

from contextlib import contextmanager
from pathlib import Path
from typing import Iterable
from urllib import request

import json


def getUrls(metadata) -> Iterable[str]:
    '''Fetch all files' URLs from Google Fonts' metadata.

    The metadata must obey the API v1 schema, and can be obtained from:
      https://www.googleapis.com/webfonts/v1/webfonts?key=${GOOGLE_FONTS_TOKEN}&family=${FAMILY}
    '''
    return ( url for i in metadata['items'] for _, url in i['files'].items() )


def hashUrl(url: str, *, hash: str = 'sha256'):
    '''Compute the hash of the data from HTTP GETing a given `url`.

    The `hash` must be an algorithm name `hashlib.new` accepts.
    '''
    import hashlib
    with request.urlopen(url) as req:
        return hashlib.new(hash, req.read())

def sriEncode(h) -> str:
    '''Encode a hash in the SRI format.

    Takes a `hashlib` object, and produces a string that
    nixpkgs' `fetchurl` accepts as `hash` parameter.
    '''
    from base64 import b64encode
    return f"{h.name}-{b64encode(h.digest()).decode()}"

def hashUrls(
    urls: Iterable[str],
    knownHashes: dict[str, str] = {},
) -> dict[str, str]:
    '''Generate a `dict` mapping URLs to SRI-encoded hashes.

    The `knownHashes` optional parameter can be used to avoid
    re-downloading files whose URL have not changed.
    '''
    return {
        url: knownHashes.get(url) or sriEncode(hashUrl(url))
        for url in urls
    }


@contextmanager
def atomicFileUpdate(target: Path):
    '''Atomically replace the contents of a file.

    Yields an open file to write into; upon exiting the context,
    the file is closed and (atomically) replaces the `target`.

    Guarantees that the `target` was either successfully overwritten
    with new content and no exception was raised, or the temporary
    file was cleaned up.
    '''
    from tempfile import mkstemp
    fd, _p = mkstemp(
        dir = target.parent,
        prefix = target.name,
    )
    tmpPath = Path(_p)

    try:
        with open(fd, 'w') as f:
            yield f

        tmpPath.replace(target)

    except Exception:
        tmpPath.unlink(missing_ok = True)
        raise


if __name__ == "__main__":
    currentDir = Path(__file__).parent

    with (currentDir / 'noto-emoji.json').open() as f:
        metadata = json.load(f)

    hashPath = currentDir / 'noto-emoji.hashes.json'
    try:
        with hashPath.open() as hashFile:
            hashes = json.load(hashFile)
    except FileNotFoundError:
        hashes = {}

    with atomicFileUpdate(hashPath) as hashFile:
        json.dump(
            hashUrls(getUrls(metadata), knownHashes = hashes),
            hashFile,
            indent = 2,
        )
        hashFile.write("\n")  # Pacify nixpkgs' dumb editor config check
