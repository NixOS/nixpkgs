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
  version = "1.2.33";
in
buildPythonPackage {
  pname = "pymctranslate";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gentlegiantJGC";
    repo = "PyMCTranslate";
    tag = version;
    hash = "sha256-9EKaDEg9IK6ozZEyx/MY3KdE0i5YOr7Oi7N1QSET6Rs=";
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
    license = with lib.licenses; [ amulet ];
    maintainers = with lib.maintainers; [ tibso ];
  };
}
