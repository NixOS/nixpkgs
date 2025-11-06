{
  lib,
  fetchPypi,
  aiohttp,
  aiohttp-apispec,
  apispec,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  libnacl,
  marshmallow,
  packaging,
  pyasn1,
  pyopenssl,
  setuptools,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pyipv8";
  version = "3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tribler";
    repo = "py-ipv8";
    tag = version;
    hash = "sha256-HamjKVuBPSicoP/GldO5kg2Eay50ti03wzeNaPAl0qI=";
  };

  build-system = [ setuptools ];

  dependencies = [
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

  doCheck = true;

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python implementation of Tribler's IPv8 p2p-networking layer";
    homepage = "https://github.com/Tribler/py-ipv8";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
