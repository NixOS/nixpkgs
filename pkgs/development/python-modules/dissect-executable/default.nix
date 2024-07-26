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
  version = "1.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.executable";
    rev = "refs/tags/${version}";
    hash = "sha256-h9eOTWJR0Bd3DY8WDYWqLCl1jYJcqP6cRTgWubf/rKI=";
  };

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
