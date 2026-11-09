{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  setuptools,

  # nativeBuildInputs
  beets-minimal,

  # dependencies
  six,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "beets-copyartifacts";
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "beets-copyartifacts";
    owner = "adammillerio";
    tag = "v${version}";
    hash = "sha256-fMnXuMwxylO9Q7EFPpkgwwNeBuviUa8HduRrqrqdMaI=";
  };

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    beets-minimal
  ];

  dependencies = [
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pytestFlags = [
    # This is the same as:
    #   -r fEs
    "-rfEs"
  ];

  meta = {
    description = "Beets plugin to move non-music files during the import process";
    homepage = "https://github.com/adammillerio/beets-copyartifacts";
    changelog = "https://github.com/adammillerio/beets-copyartifacts/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    inherit (beets-minimal.meta) platforms;
    broken = true;
  };
}
