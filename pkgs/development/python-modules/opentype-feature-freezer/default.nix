{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  pytestCheckHook,
  fonttools,
  hatch-vcs,
  hatchling,
  biplist,
}:

buildPythonPackage rec {
  pname = "opentype-feature-freezer";
  version = "1.32.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "twardoch";
    repo = "fonttools-opentype-feature-freezer";
    tag = "v${version}";
    hash = "sha256-KfNHi4LPKSvRWivBcyP5JZWbn6bAB+ccmmvIf05bAUc=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  dependencies = [ fonttools ];

  nativeCheckInputs = [
    pytestCheckHook
    biplist
  ];

  disabledTestPaths = [
    # import file mismatch
    "src/opentype_feature_freezer/cli.py"
    # NameError: name 'defines' is not defined
    "app/dmgbuild_settings.py"
    # Missing module
    "app/OTFeatureFreezer.py"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Permanently \"apply\" OpenType features to fonts, by remapping their Unicode assignments";
    homepage = "https://github.com/twardoch/fonttools-opentype-feature-freezer";
    license = lib.licenses.asl20;
    mainProgram = "pyftfeatfreeze";
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
