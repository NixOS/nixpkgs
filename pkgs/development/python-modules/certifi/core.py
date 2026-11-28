"""
certifi.core
~~~~~~~~~~~~

Returns the CA bundle named by NIX_SSL_CERT_FILE, or the system CA bundle.
"""

import functools
import os

_SYSTEM_CA_BUNDLES = (
    "/etc/ssl/certs/ca-certificates.crt",
    "/etc/ssl/ca-bundle.pem",
    "/etc/ssl/certs/ca-bundle.crt",
    "/etc/pki/tls/certs/ca-bundle.crt",
    "/etc/ssl/cert.pem",
)

@functools.cache
def _system_ca_bundle() -> str:
    for path in _SYSTEM_CA_BUNDLES:
        if os.path.exists(path):
            return path
    return _SYSTEM_CA_BUNDLES[0]

def where() -> str:
    path = os.environ.get("NIX_SSL_CERT_FILE")
    if path and path != "/no-cert-file.crt":
        return path
    return _system_ca_bundle()


def contents() -> str:
    with open(where(), encoding="utf-8") as data:
        return data.read()
