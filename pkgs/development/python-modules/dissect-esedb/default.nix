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
  version = "3.9";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.esedb";
    rev = "refs/tags/${version}";
    hash = "sha256-MdEKAArdbOG/FnTSksuJCt8o8161NY3vL0KGnUHJEdQ=";
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
