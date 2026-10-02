{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  croaring,
  hypothesis,
  pytestCheckHook,
  nix-update-script,
}:
buildPythonPackage rec {
  pname = "pyroaring";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Ezibenroc";
    repo = "PyRoaringBitMap";
    tag = version;
    hash = "sha256-hCllqGcyPRVC7Bh4gvXv0NYRCD7Hqh0OMB6Ab3miA6o=";
  };

  patches = [
    # Link against nixpkgs' croaring instead of building the vendored
    # amalgamation (pyroaring/roaring.{c,h}).
    ./use-system-croaring.patch
  ];

  postPatch = ''
    rm pyroaring/roaring.c pyroaring/roaring.h
  '';

  build-system = [
    cython
    setuptools
  ];

  buildInputs = [ croaring ];

  pythonImportsCheck = [ "pyroaring" ];

  passthru.updateScript = nix-update-script { };

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  meta = {
    description = "Python library for handling efficiently sorted integer sets";
    homepage = "https://github.com/Ezibenroc/PyRoaringBitMap";
    changelog = "https://github.com/Ezibenroc/PyRoaringBitMap/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shymega ];
  };
}
