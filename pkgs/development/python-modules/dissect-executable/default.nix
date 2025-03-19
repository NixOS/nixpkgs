{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dissect-executable";
  version = "1.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.executable";
    tag = version;
    hash = "sha256-6fEaXZTkygd0ZLPFWbtzWadA9VEsp3cd4/he0LxqhMw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dissect-cstruct
    dissect-util
  ];

  pythonImportsCheck = [ "dissect.executable" ];

  meta = with lib; {
    description = "Dissect module implementing a parser for various executable formats such as PE, ELF and Macho-O";
    homepage = "https://github.com/fox-it/dissect.executable";
    changelog = "https://github.com/fox-it/dissect.executable/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
