{
  lib,
  fetchurl,
  fetchPypi,
  buildPythonPackage,
  nix-update-script,
  zlib,

  # build-system
  setuptools,
  cython,
  versioneer,

  # dependencies
  black,
  pre-commit,
  sphinx,
  sphinx-autodoc-typehints,
  sphinx-rtd-theme,
}:
let
  version = "1.0.2";
in
buildPythonPackage {
  pname = "amulet-leveldb";
  inherit version;
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "amulet_leveldb";
    hash = "sha256-s6pRHvcb9rxrIeljlb3tDzkrHcCT71jVU1Bn2Aq0FUE=";
  };

  build-system = [
    setuptools
    cython
    versioneer
  ];

  buildInputs = [ zlib ];

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

  pythonImportsCheck = [ "leveldb" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cython wrapper for Mojang's custom LevelDB";
    homepage = "https://github.com/Amulet-Team/Amulet-LevelDB";
    license = with lib.licenses; [ amulet ];
    maintainers = with lib.maintainers; [ tibso ];
  };
}
