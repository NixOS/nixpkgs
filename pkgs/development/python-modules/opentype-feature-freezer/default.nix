{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unstableGitUpdater,
  pytestCheckHook,
  fonttools,
  poetry-core,
  configparser,
  biplist,
}:

buildPythonPackage {
  pname = "opentype-feature-freezer";
  version = "0-unstable-2022-07-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "twardoch";
    repo = "fonttools-opentype-feature-freezer";
    rev = "2ae16853bc724c3e377726f81d9fc661d3445827";
    hash = "sha256-mIWQF9LTVKxIkwHLCTVK1cOuiaduJyX8pyBZ/0RKIVE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail poetry.masonry.api poetry.core.masonry.api \
      --replace-fail "poetry>=" "poetry-core>="
  '';

  build-system = [
    poetry-core
    configparser
  ];

  dependencies = [ fonttools ];

  nativeCheckInputs = [
    pytestCheckHook
    biplist
  ];

  disabledTestPaths = [
    # Wants to check path outside of nix store
    "src/opentype_feature_freezer/cli.py"
    # NameError: name 'defines' is not defined
    "app/dmgbuild_settings.py"
    # Missing module
    "app/OTFeatureFreezer.py"
    # AttributeError: 'types.SimpleNamespace' object has no attribute 'suffix'
    "tests/test_rename.py"
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Permanently \"apply\" OpenType features to fonts, by remapping their Unicode assignments";
    homepage = "https://github.com/twardoch/fonttools-opentype-feature-freezer";
    license = lib.licenses.asl20;
    mainProgram = "pyftfeatfreeze";
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
