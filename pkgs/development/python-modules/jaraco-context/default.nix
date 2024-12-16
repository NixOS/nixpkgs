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
  version = "6.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.context";
    rev = "refs/tags/v${version}";
    hash = "sha256-WXZX2s9Qehp0F3bSv2c5lGxhhn6HKFkABbtYKizG1/8=";
  };

  pythonNamespaces = [ "jaraco" ];

  build-system = [ setuptools-scm ];

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
