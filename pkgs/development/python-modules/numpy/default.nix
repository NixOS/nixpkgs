{ lib
, fetchPypi
, python
, buildPythonPackage
, gfortran
, pytest
, blas
, lapack
, writeTextFile
, isPyPy
, cython
, setuptoolsBuildHook
 }:

assert (!blas.isILP64) && (!lapack.isILP64);

let
  cfg = writeTextFile {
    name = "site.cfg";
    text = (lib.generators.toINI {} {
      ${blas.implementation} = {
        include_dirs = "${lib.getDev blas}/include:${lib.getDev lapack}/include";
        library_dirs = "${blas}/lib:${lapack}/lib";
        libraries = "lapack,lapacke,blas,cblas";
      };
      lapack = {
        include_dirs = "${lib.getDev lapack}/include";
        library_dirs = "${lapack}/lib";
      };
      blas = {
        include_dirs = "${lib.getDev blas}/include";
        library_dirs = "${blas}/lib";
      };
    });
  };
in buildPythonPackage rec {
  pname = "numpy";
  version = "1.19.0";
  format = "pyproject.toml";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "76766cc80d6128750075378d3bb7812cf146415bd29b588616f72c943c00d598";
  };

  nativeBuildInputs = [ gfortran pytest cython setuptoolsBuildHook ];
  buildInputs = [ blas lapack ];

  patches = lib.optionals python.hasDistutilsCxxPatch [
    # We patch cpython/distutils to fix https://bugs.python.org/issue1222585
    # Patching of numpy.distutils is needed to prevent it from undoing the
    # patch to distutils.
    ./numpy-distutils-C++.patch
  ];

  preConfigure = ''
    sed -i 's/-faltivec//' numpy/distutils/system_info.py
    export NPY_NUM_BUILD_JOBS=$NIX_BUILD_CORES
  '';

  preBuild = ''
    ln -s ${cfg} site.cfg
  '';

  enableParallelBuilding = true;

  doCheck = !isPyPy; # numpy 1.16+ hits a bug in pypy's ctypes, using either numpy or pypy HEAD fixes this (https://github.com/numpy/numpy/issues/13807)

  checkPhase = ''
    runHook preCheck
    pushd dist
    ${python.interpreter} -c 'import numpy; numpy.test("fast", verbose=10)'
    popd
    runHook postCheck
  '';

  passthru = {
    # just for backwards compatibility
    blas = blas.provider;
    blasImplementation = blas.implementation;
    inherit cfg;
  };

  # Disable test
  # - test_large_file_support: takes a long time and can cause the machine to run out of disk space
  NOSE_EXCLUDE="test_large_file_support";

  meta = {
    description = "Scientific tools for Python";
    homepage = "https://numpy.org/";
    maintainers = with lib.maintainers; [ fridh ];
  };
}
