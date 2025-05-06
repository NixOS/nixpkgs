{
  lib,
  fetchurl,
  fetchPypi,
  buildPythonPackage,
  nix-update-script,

  # build-system
  setuptools,
  wheel,
  versioneer,

  # dependencies
  numpy_1,
  amulet-nbt,
  black,
  pre-commit,
  sphinx,
  sphinx-autodoc-typehints,
  sphinx-rtd-theme,
}:
let
  pname = "pymctranslate";
  version = "1.2.33";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gyzZidmbfEKcni8lSDY4HT5z1jIboQIXxwIe684s9Hs=";
  };

  build-system = [
    setuptools
    wheel
    versioneer
  ];

  dependencies = [
    numpy_1
    amulet-nbt
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

  pythonImportsCheck = [ "PyMCTranslate" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minecraft data translation system";
    homepage = "https://github.com/gentlegiantJGC/PyMCTranslate";
    license = with lib.licenses; [ amulet ];
    maintainers = with lib.maintainers; [ tibso ];
  };
}
