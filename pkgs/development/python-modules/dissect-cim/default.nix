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
  version = "3.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.cim";
    rev = version;
    hash = "sha256-d02P6RXIiriOujGns9mOkyiJLNQFNTTW61kInzS17Y4=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cstruct
    dissect-util
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dissect.cim"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the Windows Common Information Model (CIM) database";
    homepage = "https://github.com/fox-it/dissect.cim";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
