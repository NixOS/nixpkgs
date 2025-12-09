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
  pname = "dissect-fat";
  version = "3.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.fat";
    tag = version;
    hash = "sha256-BxxC+ebD8xYrBVuYmXdxPcU2JDJgWAtEBlVGqE8oVec=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dissect-cstruct
    dissect-util
  ];

  # dissect.fat.exceptions.InvalidBPB: Invalid BS_jmpBoot
  doCheck = false;

  pythonImportsCheck = [ "dissect.fat" ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the FAT file system";
    homepage = "https://github.com/fox-it/dissect.fat";
    changelog = "https://github.com/fox-it/dissect.fat/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
