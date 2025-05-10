{
  lib,
  fetchurl,
  fetchPypi,
  buildPythonPackage,
  nix-update-script,

  # build-system
  setuptools,
  cython,
  numpy_1,
  versioneer,

  # dependencies
  mutf8,
  black,
  pre-commit,
  sphinx,
  sphinx-autodoc-typehints,
  sphinx-rtd-theme,
}:
let
  version = "2.1.4";
in
buildPythonPackage {
  pname = "amulet-nbt";
  inherit version;
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "amulet_nbt";
    hash = "sha256-n99g+a5snwMPhgJeJ1rphtelEUKPuQLQyNWUgVTXS6M=";
  };

  build-system = [
    setuptools
    cython
    versioneer
    numpy_1
  ];

  dependencies = [ mutf8 ];

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

  pythonImportsCheck = [ "amulet_nbt" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python library for reading and writing binary NBT and stringified NBT";
    homepage = "https://github.com/Amulet-Team/Amulet-NBT";
    license = with lib.licenses; [ amulet ];
    maintainers = with lib.maintainers; [ tibso ];
  };
}
