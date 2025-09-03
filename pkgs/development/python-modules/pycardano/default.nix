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
  cose_0_9_dev8 = (cose.override { inherit cbor2; }).overridePythonAttrs (old: rec {
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
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Python-Cardano";
    repo = "pycardano";
    tag = "v${version}";
    hash = "sha256-W5N254tND7mI0oR82YhMFWn4zVVs3ygYOqXOBMO3sXY=";
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

  pythonRelaxDeps = [
    "ogmios"
    "websockets"
  ];

  pythonImportsCheck = [ "pycardano" ];

  meta = {
    description = "Lightweight Cardano library in Python";
    homepage = "https://github.com/Python-Cardano/pycardano";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aciceri ];
    # https://github.com/Python-Cardano/pycardano/blob/v0.13.2/Makefile#L26-L39
    # cbor2 with C extensions fail tests due to differences in used sized vs unsized arrays
    # more info: https://github.com/NixOS/nixpkgs/pull/402433#issuecomment-2916520286
    broken = cbor2.withCExtensions; # consider overriding cbor2 with cbor2WithoutCExtensions
  };
}
