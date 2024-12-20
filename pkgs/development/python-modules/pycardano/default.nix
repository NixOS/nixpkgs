{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # Python deps
  blockfrost-python,
  cachetools,
  cbor2,
  cose,
  docker,
  ecpy,
  frozendict,
  frozenlist,
  mnemonic,
  poetry-core,
  pprintpp,
  pynacl,
  setuptools,
  typeguard,
  websocket-client,
}:

let
  cose_0_9_dev8 = cose.overridePythonAttrs (old: rec {
    version = "0.9.dev8";
    src = (
      old.src.override {
        rev = "v${version}";
        hash = "sha256-/jwq2C2nvHInsgPG4jZCr+XsvlUJdYewAkasrUPVaHM=";
      }
    );
    pythonImportsCheck = [ "cose" ];
  });
in
buildPythonPackage rec {
  pname = "pycardano";
  version = "0.11.1";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Python-Cardano";
    repo = "pycardano";
    rev = "v${version}";
    hash = "sha256-OWm6ztt3s3DUbxDZqpvwTO6XwdY/57AI6Bc6x6kxH7k=";
  };

  propagatedBuildInputs = [
    blockfrost-python
    cachetools
    cbor2
    cose_0_9_dev8
    docker
    ecpy
    frozendict
    frozenlist
    mnemonic
    poetry-core
    pprintpp
    pynacl
    setuptools
    typeguard
    websocket-client
  ];

  pythonRelaxDeps = [ "typeguard" ];

  pythonImportsCheck = [ "pycardano" ];

  meta = with lib; {
    description = "Lightweight Cardano library in Python";
    homepage = "https://github.com/Python-Cardano/pycardano";
    license = licenses.mit;
    maintainers = with maintainers; [ t4ccer ];
  };
}
