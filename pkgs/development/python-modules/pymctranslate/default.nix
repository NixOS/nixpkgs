{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  pytestCheckHook,
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
  version = "1.2.35";
in
buildPythonPackage {
  pname = "pymctranslate";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gentlegiantJGC";
    repo = "PyMCTranslate";
    tag = version;
    hash = "sha256-JMF2SDi7QixCB+wcX2RVPbvPjU3rHcyXlIaR0TPHH98=";
  };

  disabled = pythonOlder "3.9";

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
  nativeCheckInputs = [ pytestCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minecraft data translation system";
    homepage = "https://github.com/gentlegiantJGC/PyMCTranslate";
    changelog = "https://github.com/gentlegiantJGC/PyMCTranslate/releases/tag/${version}";
    # polyform license: https://github.com/gentlegiantJGC/PyMCTranslate/blob/main/LICENSE
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ tibso ];
  };
}
