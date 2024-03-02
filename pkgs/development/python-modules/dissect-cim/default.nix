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
  pname = "dissect-cim";
  version = "3.7";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.cim";
    rev = "refs/tags/${version}";
    hash = "sha256-+HHjDUSepAEebMD5ckjXbfgA4AKlNMBYHwxDq+jdhxw=";
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
    "dissect.cim"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the Windows Common Information Model (CIM) database";
    homepage = "https://github.com/fox-it/dissect.cim";
    changelog = "https://github.com/fox-it/dissect.cim/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
