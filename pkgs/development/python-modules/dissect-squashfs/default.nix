{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  lz4,
  python-lzo,
  pythonOlder,
  setuptools,
  setuptools-scm,
  zstandard,
}:

buildPythonPackage rec {
  pname = "dissect-squashfs";
  version = "1.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.squashfs";
    rev = "refs/tags/${version}";
    hash = "sha256-eylLBPim3dmo8h95lRmlh8O9m458K07TH2uK+hn3nKs=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dissect-cstruct
    dissect-util
  ];

  passthru.optional-dependencies = {
    full = [
      lz4
      python-lzo
      zstandard
    ];
  };

  pythonImportsCheck = [ "dissect.squashfs" ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the SquashFS file system";
    homepage = "https://github.com/fox-it/dissect.squashfs";
    changelog = "https://github.com/fox-it/dissect.squashfs/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
