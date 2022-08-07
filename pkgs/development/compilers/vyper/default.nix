{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pythonRelaxDepsHook
, writeText
, asttokens
, pycryptodome
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
  version = "0.3.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ldNuADfWy1OWTPD7pTcpU5dX/mX2pV/QqSjJxkc5S28=";
  };

  nativeBuildInputs = [
    # Git is used in setup.py to compute version information during building
    # ever since https://github.com/vyperlang/vyper/pull/2816
    git

    pythonRelaxDepsHook
    pytest-runner
    setuptools-scm
  ];

  pythonRelaxDeps = [ "semantic-version" ];

  propagatedBuildInputs = [
    asttokens
    pycryptodome
    semantic-version

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
