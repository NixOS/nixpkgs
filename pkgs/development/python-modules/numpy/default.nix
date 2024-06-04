{
  lib,
  stdenv,
  fetchPypi,
  python,
  pythonAtLeast,
  pythonOlder,
  buildPythonPackage,
  writeTextFile,

  # build-system
  cython,
  gfortran,
  meson-python,
  mesonEmulatorHook,
  pkg-config,
  xcbuild,

  # native dependencies
  blas,
  lapack,

  # Reverse dependency
  sage,

  # tests
  hypothesis,
  pytest-xdist,
  pytestCheckHook,
  setuptools,
  typing-extensions,
}:

assert (!blas.isILP64) && (!lapack.isILP64);

let
  cfg = writeTextFile {
    name = "site.cfg";
    text = lib.generators.toINI { } {
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
in
buildPythonPackage rec {
  pname = "numpy";
  version = "1.26.4";
  pyproject = true;
  disabled = pythonOlder "3.9" || pythonAtLeast "3.13";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    hash = "sha256-KgKrqe0S5KxOs+qUIcQgMBoMZGDZgw10qd+H76SRIBA=";
  };

  patches =
    [
      # Disable `numpy/core/tests/test_umath.py::TestComplexFunctions::test_loss_of_precision[complex256]`
      # on x86_64-darwin because it fails under Rosetta 2 due to issues with trig functions and
      # 80-bit long double complex numbers.
      ./disable-failing-long-double-test-Rosetta-2.patch
    ]
    # We patch cpython/distutils to fix https://bugs.python.org/issue1222585
    # Patching of numpy.distutils is needed to prevent it from undoing the
    # patch to distutils.
    ++ lib.optionals python.hasDistutilsCxxPatch [ ./numpy-distutils-C++.patch ];

  postPatch = ''
    # fails with multiple errors because we are not using the pinned setuptools version
    # see https://github.com/numpy/numpy/blob/v1.25.0/pyproject.toml#L7
    #   error: option --single-version-externally-managed not recognized
    #   TypeError: dist must be a Distribution instance
    rm numpy/core/tests/test_cython.py

    patchShebangs numpy/_build_utils/*.py

    # remove needless reference to full Python path stored in built wheel
    substituteInPlace numpy/meson.build \
      --replace 'py.full_path()' "'python'"

    substituteInPlace pyproject.toml \
      --replace-fail "meson-python>=0.15.0,<0.16.0" "meson-python"
  '';

  nativeBuildInputs =
    [
      cython
      gfortran
      meson-python
      pkg-config
    ]
    ++ lib.optionals (stdenv.isDarwin) [ xcbuild.xcrun ]
    ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [ mesonEmulatorHook ];

  buildInputs = [
    blas
    lapack
  ];

  # Causes `error: argument unused during compilation: '-fno-strict-overflow'` due to `-Werror`.
  hardeningDisable = lib.optionals stdenv.cc.isClang [ "strictoverflow" ];

  # we default openblas to build with 64 threads
  # if a machine has more than 64 threads, it will segfault
  # see https://github.com/OpenMathLib/OpenBLAS/issues/2993
  preConfigure = ''
    sed -i 's/-faltivec//' numpy/distutils/system_info.py
    export OMP_NUM_THREADS=$((NIX_BUILD_CORES > 64 ? 64 : NIX_BUILD_CORES))
  '';

  # HACK: copy mesonEmulatorHook's flags to the variable used by meson-python
  postConfigure = ''
    mesonFlags="$mesonFlags ''${mesonFlagsArray[@]}"
  '';

  preBuild = ''
    ln -s ${cfg} site.cfg
  '';

  enableParallelBuilding = true;

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
    hypothesis
    setuptools
    typing-extensions
  ];

  preCheck = ''
    cd "$out"
  '';

  # https://github.com/numpy/numpy/blob/a277f6210739c11028f281b8495faf7da298dbef/numpy/_pytesttester.py#L180
  pytestFlagsArray = [
    "-m"
    "not\\ slow" # fast test suite
  ];

  # https://github.com/numpy/numpy/issues/24548
  disabledTests =
    lib.optionals stdenv.isi686 [
      "test_new_policy" # AssertionError: assert False
      "test_identityless_reduction_huge_array" # ValueError: Maximum allowed dimension exceeded
      "test_float_remainder_overflow" # AssertionError: FloatingPointError not raised by divmod
      "test_int" # AssertionError: selectedintkind(19): expected 16 but got -1
    ]
    ++ lib.optionals stdenv.isAarch32 [
      "test_impossible_feature_enable" # AssertionError: Failed to generate error
      "test_features" # AssertionError: Failure Detection
      "test_new_policy" # AssertionError: assert False
      "test_identityless_reduction_huge_array" # ValueError: Maximum allowed dimension exceeded
      "test_unary_spurious_fpexception" # AssertionError: Got warnings: [<warnings.WarningMessage object at 0xd1197430>]
      "test_int" # AssertionError: selectedintkind(19): expected 16 but got -1
      "test_real" # AssertionError: selectedrealkind(16): expected 10 but got -1
      "test_quad_precision" # AssertionError: selectedrealkind(32): expected 16 but got -1
      "test_big_arrays" # ValueError: array is too big; `arr.size * arr.dtype.itemsize` is larger tha...
      "test_multinomial_pvals_float32" # Failed: DID NOT RAISE <class 'ValueError'>
    ]
    ++ lib.optionals stdenv.isAarch64 [
      "test_big_arrays" # OOM on a 16G machine
    ]
    ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
      # can fail on virtualized machines confused over their cpu identity
      "test_dispatcher"
    ];

  passthru = {
    # just for backwards compatibility
    blas = blas.provider;
    blasImplementation = blas.implementation;
    inherit cfg;
    tests = {
      inherit sage;
    };
  };

  # Disable test
  # - test_large_file_support: takes a long time and can cause the machine to run out of disk space
  env.NOSE_EXCLUDE = "test_large_file_support";

  meta = {
    changelog = "https://github.com/numpy/numpy/releases/tag/v${version}";
    description = "Scientific tools for Python";
    mainProgram = "f2py";
    homepage = "https://numpy.org/";
    license = lib.licenses.bsd3;
  };
}
