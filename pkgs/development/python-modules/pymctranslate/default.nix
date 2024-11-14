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
  numpy,
  amulet-nbt,
  black,
  pre-commit,
  sphinx,
  sphinx-autodoc-typehints,
  sphinx-rtd-theme,

  pytestCheckHook,
  nix-update-script,
}:
let
  version = "1.2.30";
in
buildPythonPackage {
  pname = "pymctranslate";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gentlegiantJGC";
    repo = "PyMCTranslate";
    tag = version;
    hash = "sha256-ezLByCYaj9OwXXrvpGduQW/E+UhWexK0mFZEnxoy0ZI=";
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
    versioneer
  ];

  dependencies = [
    numpy
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

  # ¯\_(ツ)_/¯ This uses a nonexistent method for no reason - someone probably just forgot
  disabledTestPaths = [ "tests/basic_test.py" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minecraft data translation system";
    homepage = "https://github.com/gentlegiantJGC/PyMCTranslate";
    changelog = "https://github.com/gentlegiantJGC/PyMCTranslate/releases/tag/${version}";
    license = with lib.licenses; [ amulet ];
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
