{ buildPythonPackage
, lib
, stdenv
, cmake
, cppe
, eigen
, python
, pybind11
, numpy
, h5py
, numba
, scipy
, pandas
, polarizationsolver
, pytest
, llvmPackages
}:

buildPythonPackage rec {
  inherit (cppe) pname version src meta;

  # The python interface requires eigen3, but builds from a checkout in tree.
  # Using the nixpkgs version instead.
  postPatch = ''
    substituteInPlace setup.py \
      --replace "external/eigen3" "${eigen}/include/eigen3"
  '';

  nativeBuildInputs = [
    cmake
    eigen
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [ pybind11 ]
    ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  NIX_CFLAGS_LINK = lib.optional stdenv.cc.isClang "-lomp";

  hardeningDisable = lib.optional stdenv.cc.isClang "strictoverflow";

  checkInputs = [
    pytest
    h5py
    numba
    numpy
    pandas
    polarizationsolver
    scipy
  ];

  pythonImportsCheck = [ "cppe" ];
}
