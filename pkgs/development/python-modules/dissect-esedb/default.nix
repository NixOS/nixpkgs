{ lib
, buildPythonPackage
, dissect-cstruct
, dissect-util
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dissect-esedb";
  version = "3.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.esedb";
    rev = "refs/tags/${version}";
    hash = "sha256-wTzr9b95jhPbZVWM/C9T1OSBLK39sCIjbsNK/6Z83JE=";
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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dissect.esedb"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for Microsofts Extensible Storage Engine Database (ESEDB)";
    homepage = "https://github.com/fox-it/dissect.esedb";
    changelog = "https://github.com/fox-it/dissect.esedb/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
