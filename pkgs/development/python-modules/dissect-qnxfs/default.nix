{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dissect-qnxfs";
  version = "1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.qnxfs";
    tag = version;
    hash = "sha256-p+2Hs2cjqcnHsdtlbif/330WGeBNkDsGCcT+L6sEtAw=";
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
    dev = [
      dissect-cstruct
      dissect-util
    ];
  };

  pythonImportsCheck = [ "dissect.qnxfs" ];

  meta = {
    description = "Dissect module implementing a parser for the QNX4 and QNX6 file systems";
    homepage = "https://github.com/fox-it/dissect.qnxfs";
    changelog = "https://github.com/fox-it/dissect.qnxfs/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
