{ lib
, asttokens
, buildPythonPackage
, cbor2
, fetchPypi
, git
, importlib-metadata
, packaging
, pycryptodome
, pythonOlder
, recommonmark
, setuptools-scm
, sphinx
, sphinx-rtd-theme
, writeText
}:

let
  sample-contract = writeText "example.vy" ''
    count: int128

    @deploy
    def __init__(foo: address):
        self.count = 1
  '';

in
buildPythonPackage rec {
  pname = "vyper";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-locUXGoL9C3lLpIgLOmpE2SNPGV6yOXPubNaEA3EfjQ=";
  };

  postPatch = ''
    # pythonRelaxDeps doesn't work
    substituteInPlace setup.py \
      --replace-fail "setuptools_scm>=7.1.0,<8.0.0" "setuptools_scm>=7.1.0" \
      --replace-fail '"pytest-runner",' ""
  '';

  nativeBuildInputs = [
    # Git is used in setup.py to compute version information during building
    # ever since https://github.com/vyperlang/vyper/pull/2816
    git

    setuptools-scm
  ];

  pythonRelaxDeps = [
    "asttokens"
    "packaging"
  ];

  propagatedBuildInputs = [
    asttokens
    cbor2
    importlib-metadata
    packaging
    pycryptodome

    # docs
    recommonmark
    sphinx
    sphinx-rtd-theme
  ];

  checkPhase = ''
    $out/bin/vyper "${sample-contract}"
  '';

  pythonImportsCheck = [
    "vyper"
  ];

  meta = with lib; {
    description = "Pythonic Smart Contract Language for the EVM";
    homepage = "https://github.com/vyperlang/vyper";
    changelog = "https://github.com/vyperlang/vyper/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ siraben ];
  };
}
