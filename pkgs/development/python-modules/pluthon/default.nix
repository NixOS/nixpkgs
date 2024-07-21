{
  lib,
  fetchFromGitHub,
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
  version = "0.4.6";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "OpShin";
    repo = "pluthon";
    rev = version;
    hash = "sha256-ZmBkbglSbBfVhA4yP0tJdwpJiFpJ7vX0A321ldQF0lA=";
  };

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
