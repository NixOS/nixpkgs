{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "gitignore-parser";
  version = "0.1.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mherrmann";
    repo = "gitignore_parser";
    rev = "refs/tags/v${version}";
    hash = "sha256-FgP1moyfxgPmPOWpSp6+UXZOzL5HDofg3ECh53x4iaE=";
  };

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [
    "gitignore_parser"
  ];

  meta = with lib; {
    description = "A spec-compliant gitignore parser";
    homepage = "https://github.com/mherrmann/gitignore_parser";
    changelog = "https://github.com/mherrmann/gitignore_parser/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
