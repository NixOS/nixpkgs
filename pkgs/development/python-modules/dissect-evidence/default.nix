{ lib
, buildPythonPackage
, dissect-cstruct
, dissect-util
, fetchFromGitHub
, setuptools
, setuptools-scm
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dissect-evidence";
  version = "3.7";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.evidence";
    rev = "refs/tags/${version}";
    hash = "sha256-b7Ls3Xfd0scMe/gccjvRfuADITnz5QpJNLUaIgmZtpI=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cstruct
    dissect-util
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dissect.evidence"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parsers for various forensic evidence file containers";
    homepage = "https://github.com/fox-it/dissect.evidence";
    changelog = "https://github.com/fox-it/dissect.evidence/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
