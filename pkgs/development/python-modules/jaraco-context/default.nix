{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools-scm,
  backports-tarfile,
}:

buildPythonPackage rec {
  pname = "jaraco-context";
  version = "5.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.context";
    rev = "refs/tags/v${version}";
    hash = "sha256-Caj51qBLHbuiey023iLc+N2M8QiJKH8G/Pzu1v3AToU=";
  };

  pythonNamespaces = [ "jaraco" ];

  nativeBuildInputs = [ setuptools-scm ];

  dependencies = lib.optionals (pythonOlder "3.12") [ backports-tarfile ];

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
