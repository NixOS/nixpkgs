{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
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
  version = "2.1.5";
in
buildPythonPackage {
  pname = "amulet-nbt";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Amulet-Team";
    repo = "Amulet-NBT";
    tag = version;
    hash = "sha256-bpGaNEk5i5bqAgFbRGQYsFmMIntHx3sV0iPZD/HXqGQ=";
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
  nativeCheckInputs = [ pytestCheckHook ];

  # Directory conflicting with tests
  preCheck = ''
    rm -r amulet_nbt
  '';

  # Looks like a forgotten unimplemented test
  disabledTests = [ "BaseTypeTest" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python library for reading and writing binary NBT and stringified NBT";
    homepage = "https://github.com/Amulet-Team/Amulet-NBT";
    changelog = "https://github.com/Amulet-Team/Amulet-NBT/releases/tag/${version}";
    license = with lib.licenses; [ amulet ];
    maintainers = with lib.maintainers; [ tibso ];
  };
}
