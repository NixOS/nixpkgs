{
  lib,
  argon2-cffi,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  dissect-target,
  fetchFromGitHub,
  pycryptodome,
  rich,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dissect-fve";
  version = "4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.fve";
    tag = version;
    hash = "sha256-Lg29WJfXvjdhGtkZowzXgH9zzockoGkei1s9hgLr/gg=";
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

  meta = {
    description = "Dissect module implementing parsers for full volume encryption implementations";
    homepage = "https://github.com/fox-it/dissect.fve";
    changelog = "https://github.com/fox-it/dissect.fve/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
