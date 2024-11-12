{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "gitignore-parser";
  version = "0.1.11";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mherrmann";
    repo = "gitignore_parser";
    rev = "refs/tags/v${version}";
    hash = "sha256-y8A8OLgJccYWvKTJs7um8RwFFM0CswbwRojknBmk3TY=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "gitignore_parser" ];

  meta = with lib; {
    description = "Spec-compliant gitignore parser";
    homepage = "https://github.com/mherrmann/gitignore_parser";
    changelog = "https://github.com/mherrmann/gitignore_parser/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
