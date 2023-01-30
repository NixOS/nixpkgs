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
  pname = "dissect-ffs";
  version = "3.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.ffs";
    rev = version;
    hash = "sha256-kcYSoY3a8ljY9LWzOUekLBzokE+wJrG1KEr0p5CCj0U=";
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
    "dissect.ffs"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the FFS file system";
    homepage = "https://github.com/fox-it/dissect.ffs";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
