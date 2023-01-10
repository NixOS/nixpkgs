{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, setuptools-scm
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dissect-util";
  version = "3.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.util";
    rev = version;
    hash = "sha256-HGlWyRjvXu1d0n1PPkMyl8NNRRhsjMzXZJMS1MjdTWQ=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dissect.util"
  ];

  meta = with lib; {
    description = "Dissect module implementing various utility functions for the other Dissect modules";
    homepage = "https://github.com/fox-it/dissect.util";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
