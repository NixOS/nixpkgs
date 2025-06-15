{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  nix-update-script,

  # build-system
  setuptools,
  wheel,
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

  src = fetchFromGitHub {
    owner = "gentlegiantJGC";
    repo = "Minecraft-Model-Reader";
    tag = version;
    hash = "sha256-i+c5QSvGQeB5APBzN5JJ6uFohR2volX4D9qkuRQeig4=";
  };

  disabled = pythonOlder "3.9";

  build-system = [
    setuptools
    wheel
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

  # Tests are broken
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Load block models from resource packs";
    homepage = "https://github.com/gentlegiantJGC/Minecraft-Model-Reader";
    changelog = "https://github.com/gentlegiantJGC/Minecraft-Model-Reader/releases/tag/${version}";
    license = with lib.licenses; [ amulet ];
    maintainers = with lib.maintainers; [ tibso ];
  };
}
