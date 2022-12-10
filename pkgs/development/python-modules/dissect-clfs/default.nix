{ lib
, buildPythonPackage
, dissect-cstruct
, fetchFromGitHub
, setuptools
, setuptools-scm
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dissect-clfs";
  version = "1.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.clfs";
    rev = version;
    hash = "sha256-1nh81ppJpYre3y7hJ9xS+TNU1NfTH+9NMHdV55kPEXI=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cstruct
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dissect.clfs"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the CLFS (Common Log File System) file system";
    homepage = "https://github.com/fox-it/dissect.clfs";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
