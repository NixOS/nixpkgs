{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, setuptools-scm
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dissect-cstruct";
  version = "3.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.cstruct";
    rev = version;
    hash = "sha256-8OxAsrECgsQf8+EaZtJ3XNhwdhBI08o3r+xhD/D1NhQ=";
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
    "dissect.cstruct"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for C-like structures";
    homepage = "https://github.com/fox-it/dissect.cstruct";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
