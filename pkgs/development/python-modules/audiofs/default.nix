{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  fuse,
}:

buildPythonPackage {
  pname = "audiofs";
  version = "0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "steelcandy2";
    repo = "audiofs";
    rev = "4fc4a5e432c9eae6b051918d62145236d8fbbd13";
    hash = "sha256-DcLR3soQd/5iXEmqVtRMWFsQWl+MubRCx9IcucWNp7c=";
  };

  patches = [
    (fetchpatch {
      name = "drop-python2-support.patch";
      url = "https://patch-diff.githubusercontent.com/raw/steelcandy2/audiofs/pull/1.patch";
      hash = "sha256-2dVf5yXLk0e5pUKqUr5Zoc3TpPQxItjFZzida8l96wo=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ fuse ];

  pythonImportsCheck = [ "audiofs" ];

  # no tests
  doCheck = false;

  meta = {
    description = "Audio-related FUSE filesystems";
    longDescription = "Audio-related FUSE filesystems, along with optional music directory management and MPD music server integration";
    homepage = "https://github.com/steelcandy2/audiofs";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ vizid ];
  };
}
