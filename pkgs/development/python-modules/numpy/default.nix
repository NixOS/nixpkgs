{ lib
, fetchPypi
, python
, buildPythonPackage
, gfortran
, pytest
, blas
, writeTextFile
, isPyPy
, cython
, setuptoolsBuildHook
 }:

let
  blasImplementation = lib.nameFromURL blas.name "-";
  cfg = writeTextFile {
    name = "site.cfg";
    text = (lib.generators.toINI {} {
      ${blasImplementation} = {
        include_dirs = "${blas}/include";
        library_dirs = "${blas}/lib";
      } // lib.optionalAttrs (blasImplementation == "mkl") {
        mkl_libs = "mkl_rt";
        lapack_libs = "";
      };
    });
  };
in buildPythonPackage rec {
  pname = "numpy";
  version = "1.18.0";
  format = "pyproject.toml";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "a9d72d9abaf65628f0f31bbb573b7d9304e43b1e6bbae43149c17737a42764c4";
  };

  nativeBuildInputs = [ gfortran pytest cython setuptoolsBuildHook ];
  buildInputs = [ blas ];

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
    blas = blas;
    inherit blasImplementation cfg;
  };

  # Disable test
  # - test_large_file_support: takes a long time and can cause the machine to run out of disk space
  NOSE_EXCLUDE="test_large_file_support";

  meta = {
    description = "Scientific tools for Python";
    homepage = https://numpy.org/;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
