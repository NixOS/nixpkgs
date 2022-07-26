{ lib
, fetchPypi
, fetchpatch
, python
, buildPythonPackage
, gfortran
, hypothesis
, pytest
, blas
, lapack
, writeTextFile
, cython
, setuptoolsBuildHook
, pythonOlder
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

  # Attention! v1.22.0 breaks scipy and by extension scikit-learn, so
  # build both to verify they don't break.
  # https://github.com/scipy/scipy/issues/15414
  version = "1.21.6";

  format = "pyproject.toml";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-7LVSUROXBmaf3sL/BzyY746ahEc+UecWIRtBqg8Y5lY=";
  };

  patches = lib.optionals python.hasDistutilsCxxPatch [
    # We patch cpython/distutils to fix https://bugs.python.org/issue1222585
    # Patching of numpy.distutils is needed to prevent it from undoing the
    # patch to distutils.
    ./numpy-distutils-C++.patch
  ];

  nativeBuildInputs = [ gfortran cython setuptoolsBuildHook ];
  buildInputs = [ blas lapack ];

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

  checkInputs = [
    pytest
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
