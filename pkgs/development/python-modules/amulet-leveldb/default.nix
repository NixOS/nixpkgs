{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  pytestCheckHook,
  nix-update-script,
  zlib,

  # build-system
  setuptools,
  wheel,
  cython,
  versioneer,

  # dependencies
  black,
  pre-commit,
  sphinx,
  sphinx-autodoc-typehints,
  sphinx-rtd-theme,
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
    fetchSubmodules = true;

    postFetch = ''
      # De-vendor zlib
      rm -r $out/zlib
    '';
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cython wrapper for Mojang's custom LevelDB";
    homepage = "https://github.com/Amulet-Team/Amulet-LevelDB";
    changelog = "https://github.com/Amulet-Team/Amulet-LevelDB/releases/tag/${version}";
    license = with lib.licenses; [ amulet ];
    maintainers = with lib.maintainers; [ tibso ];
  };
}
