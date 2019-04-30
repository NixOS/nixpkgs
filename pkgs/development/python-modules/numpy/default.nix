{ stdenv, lib, fetchPypi, python, buildPythonPackage, gfortran, pytest, blas, writeTextFile }:

let
  blasImplementation = lib.nameFromURL blas.name "-";
  cfg = writeTextFile {
    name = "site.cfg";
    text = (lib.generators.toINI {} {
      "${blasImplementation}" = {
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
  version = "1.16.2";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1c4inssky16p6ab63n1gass6dik1dzxrp3y7kmxbdq6xg4w2wsbc";
  };

  nativeBuildInputs = [ gfortran pytest ];
  buildInputs = [ blas ];

  patches = lib.optionals (python.hasDistutilsCxxPatch or false) [
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

  # Disable two tests
  # - test_f2py: f2py isn't yet on path.
  # - test_large_file_support: takes a long time and can cause the machine to run out of disk space
  NOSE_EXCLUDE="test_f2py,test_large_file_support";

  meta = {
    description = "Scientific tools for Python";
    homepage = http://numpy.scipy.org/;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
