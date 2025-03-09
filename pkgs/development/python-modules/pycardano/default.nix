{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
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
  ogmios,
  poetry-core,
  pprintpp,
  pynacl,
  requests,
  setuptools,
  typeguard,
  websocket-client,
  websockets,
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
  version = "0.12.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Python-Cardano";
    repo = "pycardano";
    tag = "v${version}";
    hash = "sha256-jxgskdQ7Us+utndUgFYK7G2IW/e5QbeXytOsxQfFiJI=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    blockfrost-python
    cachetools
    cbor2
    cose_0_9_dev8
    docker
    ecpy
    frozendict
    frozenlist
    mnemonic
    ogmios
    poetry-core
    pprintpp
    pynacl
    requests
    typeguard
    websocket-client
    websockets
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonRelaxDeps = [ "websockets" ];

  pythonImportsCheck = [ "pycardano" ];

  meta = with lib; {
    description = "Lightweight Cardano library in Python";
    homepage = "https://github.com/Python-Cardano/pycardano";
    license = licenses.mit;
    maintainers = with maintainers; [ t4ccer ];
  };
}
