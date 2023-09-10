{ lib
, buildPythonPackage
, fetchFromGitHub
# Python deps
, blockfrost-python
, cbor2
, cose
, ecpy
, frozendict
, frozenlist
, mnemonic
, poetry-core
, pprintpp
, pynacl
, setuptools
, typeguard
, websocket-client
}:

let
  cose_0_9_dev8 = cose.overridePythonAttrs (old: rec {
    version = "0.9.dev8";
    src = (old.src.override {
      rev = "v${version}";
      hash = "sha256-/jwq2C2nvHInsgPG4jZCr+XsvlUJdYewAkasrUPVaHM=";
    });
    pythonImportsCheck = [ "cose" ];
  });

in buildPythonPackage rec {
  pname = "pycardano";
  version = "0.9.0";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Python-Cardano";
    repo = "pycardano";
    rev = "v${version}";
    hash = "sha256-KRlpGhEzABBh1YWCDcrpW4hyMOhEA1Rla9nh95qdVik=";
  };

  propagatedBuildInputs = [
    blockfrost-python
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

  pythonImportsCheck = [ "pycardano" ];

  meta = with lib; {
    description = "A lightweight Cardano library in Python";
    homepage = "https://github.com/Python-Cardano/pycardano";
    license = licenses.mit;
    maintainers = with maintainers; [ t4ccer ];
  };
}
