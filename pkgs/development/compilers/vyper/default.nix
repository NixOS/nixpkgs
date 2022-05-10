{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pythonAtLeast
, pythonRelaxDepsHook
, writeText
, asttokens
, pycryptodome
, recommonmark
, semantic-version
, sphinx
, sphinx_rtd_theme
, pytest-runner
, setuptools-scm
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
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7" || pythonAtLeast "3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fXug5v3zstz19uexMWokHBVsfcl2ZCdIOIXKeLVyh/Q=";
  };

  nativeBuildInputs = [
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
    sphinx_rtd_theme
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
