{ lib
, stdenv
, fetchPypi
, fetchpatch
, python
, buildPythonPackage
, gfortran
, hypothesis
, pytest
, typing-extensions
, blas
, lapack
, writeTextFile
, cython
, pythonOlder
}:

assert (!blas.isILP64) && (!lapack.isILP64);

let
  cfg = writeTextFile {
    name = "site.cfg";
    text = lib.generators.toINI {} {
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
    };
  };
in buildPythonPackage (rec {
  pname = "numpy";
  version = "1.24.2";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    hash = "sha256-ADqfUw6IDLLNF3y6GvciC5qkLe+cSvwqL8Pua+frKyI=";
  };

  patches = lib.optionals python.hasDistutilsCxxPatch [
    # We patch cpython/distutils to fix https://bugs.python.org/issue1222585
    # Patching of numpy.distutils is needed to prevent it from undoing the
    # patch to distutils.
    ./numpy-distutils-C++.patch
  ]
  ++ lib.optionals stdenv.cc.isClang [
    # f2py.f90mod_rules generates code with invalid function pointer conversions, which are
    # clang 16 makes an error by default.
    (fetchpatch {
      url = "https://github.com/numpy/numpy/commit/609fee4324f3521d81a3454f5fcc33abb0d3761e.patch";
      hash = "sha256-6Dbmf/RWvQJPTIjvchVaywHGcKCsgap/0wAp5WswuCo=";
    })
  ]
  ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # Backport from 1.25. `platform.machine` returns `arm64` on aarch64-darwin, which causes
    # differing results between `_selected_real_kind_func` and Fortran’s `selected_real_kind`.
    (fetchpatch {
      url = "https://github.com/numpy/numpy/commit/afcedf4b63f4a94187e6995c2adea0da3bb18e83.patch";
      hash = "sha256-cxBoimX5a9wC2qUIGAo5o/M2E9+eV63bV2/wLmfDYKg=";
    })
  ]
  ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    # Disable `numpy/core/tests/test_umath.py::TestComplexFunctions::test_loss_of_precision[complex256]`
    # on x86_64-darwin because it fails under Rosetta 2 due to issues with trig functions and
    # 80-bit long double complex numbers.
    ./disable-failing-long-double-test-Rosetta-2.patch
  ];

  postPatch = ''
    # fails with multiple errors because we are not using the pinned setuptools version
    # see https://github.com/numpy/numpy/blob/v1.25.0/pyproject.toml#L7
    #   error: option --single-version-externally-managed not recognized
    #   TypeError: dist must be a Distribution instance
    rm numpy/core/tests/test_cython.py
  '';

  nativeBuildInputs = [ gfortran cython ];
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

  nativeCheckInputs = [
    pytest
    hypothesis
    typing-extensions
  ];

  checkPhase = ''
    runHook preCheck
    pushd "$out"
    ${python.interpreter} -c 'import numpy, sys; sys.exit(numpy.test("fast", verbose=10) is False)'
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
} // lib.optionalAttrs stdenv.cc.isClang {
  # Causes `error: argument unused during compilation: '-fno-strict-overflow'` due to `-Werror`.
  hardeningDisable = [ "strictoverflow" ];
})
