{
  lib,
  buildPythonPackage,
  fetchpatch,
  fetchFromGitHub,
  stdenv,

  # nativeBuildInputs
  cmake,
  pybind11,

  # buildInputs
  abseil-cpp,

  # build-system
  setuptools,

  # checks
  absl-py,
  attrs,
  numpy,
  wrapt,
}:
let
  patchCMakeAbseil = fetchpatch {
    name = "0001-don-t-rebuild-abseil.patch";
    url = "https://raw.githubusercontent.com/conda-forge/dm-tree-feedstock/93a91aa2c13240cecf88133e2885ade9121b464a/recipe/patches/0001-don-t-rebuild-abseil.patch";
    hash = "sha256-bho7lXAV5xHkPmWy94THJtx+6i+px5w6xKKfThvBO/M=";
  };
  patchCMakePybind = fetchpatch {
    name = "0002-don-t-fetch-pybind11.patch";
    url = "https://raw.githubusercontent.com/conda-forge/dm-tree-feedstock/93a91aa2c13240cecf88133e2885ade9121b464a/recipe/patches/0002-don-t-fetch-pybind11.patch";
    hash = "sha256-41XIouQ4Fm1yewaxK9erfcnkGBS6vgdvMm/DyF0rsKg=";
  };
in
buildPythonPackage rec {
  pname = "dm-tree";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "tree";
    rev = "refs/tags/${version}";
    hash = "sha256-VvSJTuEYjIz/4TTibSLkbg65YmcYqHImTHOomeorMJc=";
  };

  patches = [
    patchCMakeAbseil
    patchCMakePybind
  ] ++ (lib.optional stdenv.hostPlatform.isDarwin ./0003-don-t-configure-apple.patch);

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    pybind11
  ];

  buildInputs = [
    abseil-cpp
    pybind11
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [
    absl-py
    attrs
    numpy
    wrapt
  ];

  pythonImportsCheck = [ "tree" ];

  meta = {
    description = "Tree is a library for working with nested data structures";
    homepage = "https://github.com/deepmind/tree";
    changelog = "https://github.com/google-deepmind/tree/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      samuela
      ndl
    ];
  };
}
