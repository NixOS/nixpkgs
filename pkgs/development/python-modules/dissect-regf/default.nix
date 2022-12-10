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
  pname = "dissect-regf";
  version = "3.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.regf";
    rev = version;
    hash = "sha256-hSMdgGkSmFDAiO6C1xTJDmKClHwrGc887wqO3/5NZn4=";
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
    "dissect.regf"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for Windows registry file format";
    homepage = "https://github.com/fox-it/dissect.regf";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
