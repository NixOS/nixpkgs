{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonRelaxDepsHook,
  # Python deps
  blockfrost-python,
  cachetools,
  cbor2,
  cose,
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
  version = "0.10.0";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Python-Cardano";
    repo = "pycardano";
    rev = "v${version}";
    hash = "sha256-LP/W8IC2del476fGFq10VMWwMrbAoCCcZOngA8unBM0=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  propagatedBuildInputs = [
    blockfrost-python
    cachetools
    cbor2
    cose_0_9_dev8
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
