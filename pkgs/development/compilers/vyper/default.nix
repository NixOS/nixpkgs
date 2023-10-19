{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pythonRelaxDepsHook
, writeText
, asttokens
, pycryptodome
, importlib-metadata
, cbor2
, recommonmark
, semantic-version
, sphinx
, sphinx-rtd-theme
, pytest-runner
, setuptools-scm
, git
}:

let
  sample-contract = writeText "example.vy" ''
    count: int128

    @external
    def __init__(foo: address):
        self.count = 1
  '';

in
buildPythonPackage rec {
  pname = "vyper";
  version = "0.3.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jcH1AcqrQX+wzpxoppRFh/AUfsfMfTiJzzpFwZRm5Ik=";
  };

  nativeBuildInputs = [
    # Git is used in setup.py to compute version information during building
    # ever since https://github.com/vyperlang/vyper/pull/2816
    git

    pythonRelaxDepsHook
    pytest-runner
    setuptools-scm
  ];

  pythonRelaxDeps = [ "asttokens" "semantic-version" ];

  propagatedBuildInputs = [
    asttokens
    pycryptodome
    semantic-version
    importlib-metadata
    cbor2

    # docs
    recommonmark
    sphinx
    sphinx-rtd-theme
  ];

  checkPhase = ''
    $out/bin/vyper "${sample-contract}"
  '';

  meta = with lib; {
    description = "Pythonic Smart Contract Language for the EVM";
    homepage = "https://github.com/vyperlang/vyper";
    license = licenses.asl20;
    maintainers = with maintainers; [ siraben ];
  };
}
