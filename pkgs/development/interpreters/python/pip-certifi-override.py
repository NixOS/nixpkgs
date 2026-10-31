# appended to pip/_vendor/certifi/core.py; uses its where()
import os as _nix_os

_nix_vendored_where = where


def _nix_system_bundle():
    for path in (
        _nix_os.environ.get("NIX_SSL_CERT_FILE"),
        _nix_os.environ.get("SSL_CERT_FILE"),
        "/etc/ssl/certs/ca-certificates.crt",
        "/etc/ssl/cert.pem",
    ):
        if path and _nix_os.path.isfile(path):
            return path
    return None


def where() -> str:
    return _nix_system_bundle() or _nix_vendored_where()


def contents() -> str:
    path = _nix_system_bundle()
    if path is None:
        path = _nix_vendored_where()
    with open(path, encoding="utf-8") as f:
        return f.read()
