{
  lib,
  fetchPypi,
  buildPythonPackage,
  fetchFromGitHub,
  cryptography,
  libnacl,
  aiohttp,
  aiohttp-apispec,
  pyopenssl,
  pyasn1,
  marshmallow,
  typing-extensions,
  packaging,
  apispec,
}:

buildPythonPackage {
  pname = "pyipv8";
  version = "3.0.2197-unstable-2025-07-29";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "tribler";
    repo = "py-ipv8";
    rev = "db39b85f4c28880dee24d1b59d8eae8ca8b9c03d";
    hash = "sha256-VIcBPzpK8Cdaz/dRp9QK/MtK41jm8rs/pxnLS716FNM=";
  };

  propagatedBuildInputs = [
    cryptography
    libnacl
    aiohttp
    aiohttp-apispec
    pyopenssl
    pyasn1
    marshmallow
    typing-extensions
    packaging
    apispec
  ];

  doCheck = false;

  meta = with lib; {
    description = "Python implementation of Tribler's IPv8 p2p-networking layer";
    homepage = "https://github.com/Tribler/py-ipv8";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
