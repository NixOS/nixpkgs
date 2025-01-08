{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,
  wheel,
  versioneer,

  # dependencies
  pillow,
  numpy,
  amulet-nbt,
  platformdirs,
  black,
  pre-commit,
  sphinx,
  sphinx-autodoc-typehints,
  sphinx-rtd-theme,

  nix-update-script,
}:
let
  version = "1.4.6";
in
buildPythonPackage {
  pname = "minecraft-resource-pack";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gentlegiantJGC";
    repo = "Minecraft-Model-Reader";
    tag = version;
    hash = "sha256-i+c5QSvGQeB5APBzN5JJ6uFohR2volX4D9qkuRQeig4=";
  };

  disabled = pythonOlder "3.9";

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "versioneer.get_version()" "'${version}'"
  '';

  build-system = [
    setuptools
    wheel
    versioneer
  ];

  dependencies = [
    pillow
    numpy
    amulet-nbt
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

  pythonRelaxDeps = [ "platformdirs" ];

  pythonImportsCheck = [ "minecraft_model_reader" ];

  # minecraft_model_reader/api/amulet/block.py:132: in __init__
  #    assert isinstance(properties, dict) and all(
  #E   AssertionError: {'age': '0', 'east': 'true', 'north': 'true', 'south': 'false', 'up': 'false', 'west': 'false'}
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python library for reading and writing binary NBT and stringified NBT";
    homepage = "https://github.com/Amulet-Team/Amulet-NBT";
    changelog = "https://github.com/Amulet-Team/Amulet-NBT/releases/tag/${version}";
    license = with lib.licenses; [ amulet ];
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
