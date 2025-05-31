{
  lib,
  fetchurl,
  fetchPypi,
  buildPythonPackage,
  nix-update-script,

  # build-system
  setuptools,
  cython,
  versioneer,
  numpy_1,

  # dependencies
  amulet-nbt,
  amulet-leveldb,
  pymctranslate,
  lz4,
  portalocker,
  platformdirs,
  black,
  pre-commit,
  sphinx,
  sphinx-autodoc-typehints,
  sphinx-rtd-theme,
}:
let
  version = "1.9.29";
in
buildPythonPackage {
  pname = "amulet-core";
  inherit version;
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "amulet_core";
    hash = "sha256-aoqnCqracfKJKSBBQSG4OsPlmgPooowmkC1xPNDCVk0=";
  };

  build-system = [
    setuptools
    cython
    versioneer
    numpy_1
  ];

  dependencies = [
    amulet-nbt
    amulet-leveldb
    pymctranslate
    lz4
    portalocker
    platformdirs
  ];

  optional-dependencies = {
    dev = [
      black
      pre-commit
    ];
    docs = [
      sphinx
      sphinx-autodoc-typehints
      sphinx-rtd-theme
    ];
  };

  # "requirements.py" is asking for older versions
  pythonRelaxDeps = [
    "portalocker"
    "platformdirs"
  ];

  pythonImportsCheck = [ "amulet" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python library for reading and writing the Minecraft save formats";
    homepage = "https://github.com/Amulet-Team/Amulet-Core";
    license = with lib.licenses; [ amulet ];
    maintainers = with lib.maintainers; [ tibso ];
  };
}
