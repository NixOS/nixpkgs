{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,
  wheel,
  versioneer,
  cython,

  # dependencies
  numpy,
  mutf8,
  black,
  pre-commit,
  sphinx,
  sphinx-autodoc-typehints,
  sphinx-rtd-theme,

  pytestCheckHook,
  nix-update-script,
}:
let
  version = "2.1.3";
in
buildPythonPackage {
  pname = "amulet-nbt";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Amulet-Team";
    repo = "Amulet-NBT";
    tag = version;
    hash = "sha256-ucN/CFPYWEPPiqrK9v2VZ1l5s2jf0N0tNuxpYoTZQ4s=";
  };

  disabled = pythonOlder "3.9";

  postPatch = ''
    # FIXME: Drop for 4.x
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
    mutf8
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

  pythonImportsCheck = [ "amulet_nbt" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Source files interfere with tests :(
  preCheck = ''
    rm -r amulet_nbt
  '';

  # FIXME: Drop for 4.x, somehow it's just not implemented at all
  disabledTestPaths = [ "tests/base_type_test.py" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python library for reading and writing binary NBT and stringified NBT";
    homepage = "https://github.com/Amulet-Team/Amulet-NBT";
    changelog = "https://github.com/Amulet-Team/Amulet-NBT/releases/tag/${version}";
    license = with lib.licenses; [ amulet ];
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
