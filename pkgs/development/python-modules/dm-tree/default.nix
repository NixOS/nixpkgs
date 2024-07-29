{
  stdenv,
  abseil-cpp,
  absl-py,
  attrs,
  buildPythonPackage,
  cmake,
  fetchpatch,
  fetchFromGitHub,
  lib,
  numpy,
  pybind11,
  wrapt,
}:
let
  patchCMakeAbseil = fetchpatch {
    name = "0001-don-t-rebuild-abseil.patch";
    url = "https://raw.githubusercontent.com/conda-forge/dm-tree-feedstock/93a91aa2c13240cecf88133e2885ade9121b464a/recipe/patches/0001-don-t-rebuild-abseil.patch";
    hash = "sha256-mCnyAaHBCZJBogGfl0Hx+hocmtFg13RAIUbEy93z2CE=";
  };
  patchCMakePybind = fetchpatch {
    name = "0002-don-t-fetch-pybind11.patch";
    url = "https://raw.githubusercontent.com/conda-forge/dm-tree-feedstock/93a91aa2c13240cecf88133e2885ade9121b464a/recipe/patches/0002-don-t-fetch-pybind11.patch";
    hash = "sha256-zGgeAhIMHA238vESWb+44s9p0QjQxnpgMAGv88uYGMU=";
  };
in
buildPythonPackage rec {
  pname = "dm-tree";
  version = "0.1.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "tree";
    rev = "refs/tags/${version}";
    hash = "sha256-VvSJTuEYjIz/4TTibSLkbg65YmcYqHImTHOomeorMJc=";
  };

  patches = [
    patchCMakeAbseil
    patchCMakePybind
  ] ++ (lib.optional stdenv.isDarwin ./0003-don-t-configure-apple.patch);

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    pybind11
  ];

  buildInputs = [
    abseil-cpp
    pybind11
  ];

  nativeCheckInputs = [
    absl-py
    attrs
    numpy
    wrapt
  ];

  pythonImportsCheck = [ "tree" ];

  meta = with lib; {
    description = "Tree is a library for working with nested data structures";
    homepage = "https://github.com/deepmind/tree";
    license = licenses.asl20;
    maintainers = with maintainers; [
      samuela
      ndl
    ];
  };
}
