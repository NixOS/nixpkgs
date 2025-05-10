{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  # Python deps
  blockfrost-python,
  cachetools,
  # https://github.com/Python-Cardano/pycardano/blob/v0.13.2/Makefile#L26-L39
  # If we do not do it then tests fail due to differences in used sized vs unsized arrays
  cbor2WithoutCExtensions,
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
  cose_0_9_dev8 = (cose.override { cbor2 = cbor2WithoutCExtensions; }).overridePythonAttrs (old: rec {
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
  version = "0.13.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Python-Cardano";
    repo = "pycardano";
    tag = "v${version}";
    hash = "sha256-v3ZnyVDbRkW+rbw2rRGGcdlsXpTB1mE6cEYoS/fqzbc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    blockfrost-python
    cachetools
    cbor2WithoutCExtensions
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

  pythonRelaxDeps = [
    "ogmios"
    "websockets"
  ];

  pythonImportsCheck = [ "pycardano" ];

  meta = {
    description = "Lightweight Cardano library in Python";
    homepage = "https://github.com/Python-Cardano/pycardano";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ t4ccer ];
  };
}
