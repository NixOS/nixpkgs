{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  lz4,
  python-lzo,
  setuptools,
  setuptools-scm,
  zstandard,
}:

buildPythonPackage rec {
  pname = "dissect-squashfs";
  version = "1.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.squashfs";
    tag = version;
    hash = "sha256-glmrsbNkhgYBhcL+qgEnBfJnGL4ViHH1L5HN9rGlUNM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dissect-cstruct
    dissect-util
  ];

  optional-dependencies = {
    full = [
      lz4
      python-lzo
      zstandard
    ];
  };

  pythonImportsCheck = [ "dissect.squashfs" ];

  meta = {
    description = "Dissect module implementing a parser for the SquashFS file system";
    homepage = "https://github.com/fox-it/dissect.squashfs";
    changelog = "https://github.com/fox-it/dissect.squashfs/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
