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
  pname = "dissect-fat";
  version = "3.10";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.fat";
    rev = "refs/tags/${version}";
    hash = "sha256-jwTHvh1fqmVisW5rYDa5mOD1MMdBb10EHo945WHBnp8=";
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
    changelog = "https://github.com/fox-it/dissect.fat/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
