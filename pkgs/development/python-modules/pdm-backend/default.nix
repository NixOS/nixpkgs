{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub

# propagates
, importlib-metadata

# tests
, editables
, git
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "pdm-backend";
  version = "2.0.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pdm-project";
    repo = "pdm-backend";
    rev = "refs/tags/${version}";
    hash = "sha256-NMnb9DiW5xvfsI1nHFNIwvA/yH2boqe+WeD5re/ojAM=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  pythonImportsCheck = [
    "pdm.backend"
  ];

  nativeCheckInputs = [
    editables
    git
    pytestCheckHook
    setuptools
  ];

  meta = with lib; {
    homepage = "https://github.com/pdm-project/pdm-backend";
    changelog = "https://github.com/pdm-project/pdm-backend/releases/tag/${version}";
    description = "Yet another PEP 517 backend.";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
