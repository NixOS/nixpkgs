{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  pythonOlder,
  nix-update-script,

  # build-system
  setuptools,
  wheel,
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
  version = "1.9.30";
in
buildPythonPackage {
  pname = "amulet-core";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Amulet-Team";
    repo = "Amulet-Core";
    tag = version;
    hash = "sha256-r4i74vo/lLqeOgedaRniwQgqUBts4UwtbHJWgnd+mCM=";
  };

  disabled = pythonOlder "3.9";

  build-system = [
    setuptools
    wheel
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
  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python library for reading and writing the Minecraft save formats";
    homepage = "https://github.com/Amulet-Team/Amulet-Core";
    changelog = "https://github.com/Amulet-Team/Amulet-Core/releases/tag/${version}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ tibso ];
  };
}
