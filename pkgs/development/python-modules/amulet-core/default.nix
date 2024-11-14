{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,
  wheel,
  cython,
  versioneer,
  numpy,

  # dependencies
  amulet-nbt,
  pymctranslate,
  portalocker,
  amulet-leveldb,
  platformdirs,
  lz4,
  black,
  pre-commit,
  sphinx,
  sphinx-autodoc-typehints,
  sphinx-rtd-theme,

  pytestCheckHook,
  nix-update-script,
}:
let
  version = "1.9.27";
in
buildPythonPackage {
  pname = "amulet-core";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Amulet-Team";
    repo = "Amulet-Core";
    tag = version;
    hash = "sha256-cwk70qg97BIFPTpBnGG5WQElzvS5CYP5HIEIYd0w96I=";
  };

  disabled = pythonOlder "3.9";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'versioneer-518' 'versioneer'

    substituteInPlace setup.py \
      --replace-fail "versioneer.get_version()" "'${version}'"
  '';

  build-system = [
    setuptools
    wheel
    cython
    versioneer
    numpy
  ];

  dependencies = [
    numpy
    amulet-nbt
    pymctranslate
    portalocker
    amulet-leveldb
    platformdirs
    lz4
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

  pythonImportsCheck = [ "amulet" ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    # Required for tests that want to write to the home directory
    export HOME=$(mktemp -d)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python library for reading and writing the Minecraft save formats";
    homepage = "https://github.com/Amulet-Team/Amulet-Core";
    changelog = "https://github.com/Amulet-Team/Amulet-Core/releases/tag/${version}";
    license = with lib.licenses; [ amulet ];
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
