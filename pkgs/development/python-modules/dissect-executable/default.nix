{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "dissect-executable";
  version = "1.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.executable";
    tag = version;
    hash = "sha256-TbygZJjdTfNvwEHmquiXfalu73XgNPZpar50YpxP6NA=";
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
