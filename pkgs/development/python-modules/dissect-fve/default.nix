{
  lib,
  argon2-cffi,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  dissect-target,
  fetchFromGitHub,
  pycryptodome,
  pythonOlder,
  rich,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dissect-fve";
  version = "4.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.fve";
    tag = version;
    hash = "sha256-R6ZrUofycEgJlwLE4/CXFZ2gTg+ETBPlBBC8+s5YN6M=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    argon2-cffi
    dissect-cstruct
    dissect-util
    pycryptodome
  ];

  optional-dependencies = {
    full = [
      dissect-target
      rich
    ];
  };

  pythonImportsCheck = [ "dissect.fve" ];

  meta = with lib; {
    description = "Dissect module implementing parsers for full volume encryption implementations";
    homepage = "https://github.com/fox-it/dissect.fve";
    changelog = "https://github.com/fox-it/dissect.fve/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
