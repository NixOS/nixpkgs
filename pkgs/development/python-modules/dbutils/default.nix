{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dbutils";
  version = "3.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WebwareForPython";
    repo = "DBUtils";
    tag = "Release-${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-YyZKGN7oNuCR4lU7pxkY+vLOWGQzQjqvAIOZc7LlvUM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dbutils" ];

  meta = {
    description = "Database connections for multi-threaded environments";
    homepage = "https://webwareforpython.github.io/DBUtils/";
    changelog = "https://webwareforpython.github.io/DBUtils/changelog.html";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
