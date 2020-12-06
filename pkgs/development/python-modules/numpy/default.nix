{ lib
, fetchPypi
, python
, buildPythonPackage
, gfortran
, hypothesis
, pytest_5
, blas
, lapack
, writeTextFile
, isPyPy
, cython
, setuptoolsBuildHook
, fetchpatch
 }:

assert (!blas.isILP64) && (!lapack.isILP64);

let
  cfg = writeTextFile {
    name = "site.cfg";
    text = (lib.generators.toINI {} {
      ${blas.implementation} = {
        include_dirs = "${lib.getDev blas}/include:${lib.getDev lapack}/include";
        library_dirs = "${blas}/lib:${lapack}/lib";
        runtime_library_dirs = "${blas}/lib:${lapack}/lib";
        libraries = "lapack,lapacke,blas,cblas";
      };
      lapack = {
        include_dirs = "${lib.getDev lapack}/include";
        library_dirs = "${lapack}/lib";
        runtime_library_dirs = "${lapack}/lib";
      };
      blas = {
        include_dirs = "${lib.getDev blas}/include";
        library_dirs = "${blas}/lib";
        runtime_library_dirs = "${blas}/lib";
      };
    });
  };
in buildPythonPackage rec {
  pname = "numpy";
  version = "1.19.4";
  format = "pyproject.toml";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "141ec3a3300ab89c7f2b0775289954d193cc8edb621ea05f99db9cb181530512";
  };

  nativeBuildInputs = [ gfortran cython setuptoolsBuildHook ];
  buildInputs = [ blas lapack ];

  patches = [
    # For compatibility with newer pytest
    (fetchpatch {
      url = "https://github.com/numpy/numpy/commit/ba315034759fbf91c61bb55390edc86e7b2627f3.patch";
      sha256 = "F2P5q61CyhqsZfwkLmxb7A9YdE+43FXLbQkSjop2rVY=";
    })
  ] ++ lib.optionals python.hasDistutilsCxxPatch [
    # We patch cpython/distutils to fix https://bugs.python.org/issue1222585
    # Patching of numpy.distutils is needed to prevent it from undoing the
    # patch to distutils.
    ./numpy-distutils-C++.patch
  ];

  # we default openblas to build with 64 threads
  # if a machine has more than 64 threads, it will segfault
  # see https://github.com/xianyi/OpenBLAS/issues/2993
  preConfigure = ''
    sed -i 's/-faltivec//' numpy/distutils/system_info.py
    export NPY_NUM_BUILD_JOBS=$NIX_BUILD_CORES
    export OMP_NUM_THREADS=$((NIX_BUILD_CORES > 64 ? 64 : NIX_BUILD_CORES))
  '';

  preBuild = ''
    ln -s ${cfg} site.cfg
  '';

  enableParallelBuilding = true;

  doCheck = !isPyPy; # numpy 1.16+ hits a bug in pypy's ctypes, using either numpy or pypy HEAD fixes this (https://github.com/numpy/numpy/issues/13807)

  checkInputs = [
    pytest_5 # pytest 6 will error: "module is already imported: hypothesis"
    hypothesis
  ];

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
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
