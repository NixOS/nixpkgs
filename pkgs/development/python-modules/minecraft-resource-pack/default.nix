{
  lib,
  fetchurl,
  fetchPypi,
  buildPythonPackage,
  nix-update-script,

  # build-system
  setuptools,
  versioneer,

  # dependencies
  pillow,
  numpy_1,
  amulet-nbt,
  platformdirs,
  black,
  mypy,
  pre-commit,
  sphinx,
  sphinx-autodoc-typehints,
  sphinx-rtd-theme,
}:
let
  version = "1.4.6";
in
buildPythonPackage {
  pname = "minecraft-resource-pack";
  inherit version;
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "minecraft_resource_pack";
    hash = "sha256-ZBl0r+Nxwf1hl51a17WZEXUeFFq5a08kUeD4VSI2Rhk=";
  };

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    pillow
    numpy_1
    amulet-nbt
    platformdirs
  ];

  optional-dependencies = {
    dev = [
      black
      mypy
      pre-commit
    ];
    docs = [
      sphinx
      sphinx-autodoc-typehints
      sphinx-rtd-theme
    ];
  };

  # "requirements.py" is asking for older versions
  pythonRelaxDeps = [ "platformdirs" ];

  pythonImportsCheck = [ "minecraft_model_reader" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python library for reading and writing binary NBT and stringified NBT";
    homepage = "https://github.com/gentlegiantJGC/Minecraft-Model-Reader";
    license = with lib.licenses; [ amulet ];
    maintainers = with lib.maintainers; [ tibso ];
  };
}
