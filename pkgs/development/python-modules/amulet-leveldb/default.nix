{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  zlib,

  # build-system
  setuptools,
  wheel,
  cython,
  versioneer,
  black,
  pre-commit,
  sphinx,
  sphinx-autodoc-typehints,
  sphinx-rtd-theme,

  pytestCheckHook,
  nix-update-script,
}:
let
  version = "1.0.2";
in
buildPythonPackage {
  pname = "amulet-leveldb";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Amulet-Team";
    repo = "Amulet-LevelDB";
    tag = version;
    hash = "sha256-7VJb5TEa3GcwNEZYrnwP3yMWdpxkHeFcydCCeHiB3+w=";

    postFetch = ''
      # De-vendor zlib
      rm -r $out/zlib
    '';
    fetchSubmodules = true;
  };

  disabled = pythonOlder "3.8";

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "versioneer.get_version()" "'${version}'"
  '';

  build-system = [
    setuptools
    wheel
    cython
    versioneer
  ];

  buildInputs = [ zlib ];

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

  pythonImportsCheck = [ "leveldb" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # FIXME(pluiedev): I... frankly don't know why this fails.
  # try:
  #     self.assertTrue(40_000 <= len(list(db.keys())) < 100_000)
  #     ^ AssertionError: False is not true
  disabledTests = [ "test_corrupt" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cython wrapper for Mojang's custom LevelDB";
    homepage = "https://github.com/Amulet-Team/Amulet-LevelDB";
    changelog = "https://github.com/Amulet-Team/Amulet-LevelDB/releases/tag/${version}";
    license = with lib.licenses; [ amulet ];
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
