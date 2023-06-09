{ lib
, buildPythonPackage
, dissect-cstruct
, dissect-util
, fetchFromGitHub
, setuptools
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dissect-executable";
  version = "1.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.executable";
    rev = "refs/tags/${version}";
    hash = "sha256-YGpClgRVW8l5Ln6e3RrH1RhOSuZ/A6Kfjf1plomWE9U=";
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

  pythonImportsCheck = [
    "dissect.executable"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for various executable formats such as PE, ELF and Macho-O";
    homepage = "https://github.com/fox-it/dissect.executable";
    changelog = "https://github.com/fox-it/dissect.executable/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
