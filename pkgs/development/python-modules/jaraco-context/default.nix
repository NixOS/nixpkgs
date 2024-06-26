{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "jaraco-context";
  version = "4.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.context";
    rev = "refs/tags/v${version}";
    hash = "sha256-YdbkpKv7k62uyhmjKoxeA9uf5BWnRD/rK+z46FJN4xk=";
  };

  pythonNamespaces = [ "jaraco" ];

  nativeBuildInputs = [ setuptools-scm ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "jaraco.context" ];

  meta = with lib; {
    description = "Python module for context management";
    homepage = "https://github.com/jaraco/jaraco.context";
    changelog = "https://github.com/jaraco/jaraco.context/blob/v${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
