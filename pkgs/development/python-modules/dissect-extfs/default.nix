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
  pname = "dissect-extfs";
  version = "3.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.extfs";
    rev = version;
    hash = "sha256-i52hlTh0uJJcprA6oVlFQ3v6BpOtSnQAQ0p6BHt56Ac=";
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
    "dissect.extfs"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the ExtFS file system";
    homepage = "https://github.com/fox-it/dissect.extfs";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
