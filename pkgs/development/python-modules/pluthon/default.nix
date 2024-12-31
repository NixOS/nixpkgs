{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  buildPythonPackage,
  setuptools,
  pythonOlder,
  # Python deps
  uplc,
  graphlib-backport,
  ordered-set,
}:

buildPythonPackage rec {
  pname = "pluthon";
  version = "0.5.3";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "OpShin";
    repo = "pluthon";
    rev = version;
    hash = "sha256-pX/XPZJQZaSY06nLLEvhf+1LEqYG3CdgPV/3Q6XOzTs=";
  };

  patches = [
    (fetchpatch2 {
      name = "pluthon-bump-uplc.patch";
      # https://github.com/OpShin/pluthon/pull/21
      url = "https://github.com/OpShin/pluthon/commit/4b0a40223f253643056cab12231264c5beffc666.patch?full_index=1";
      hash = "sha256-dO9JaIpkugZFKsr3Hd0cFCy7K+cmf77UfrdkZ+sGQtA=";
    })
  ];

  propagatedBuildInputs = [
    setuptools
    uplc
    ordered-set
  ] ++ lib.optional (pythonOlder "3.9") graphlib-backport;

  pythonImportsCheck = [ "pluthon" ];

  meta = with lib; {
    description = "Pluto-like programming language for Cardano Smart Contracts in Python";
    homepage = "https://github.com/OpShin/pluthon";
    license = licenses.mit;
    maintainers = with maintainers; [ t4ccer ];
  };
}
