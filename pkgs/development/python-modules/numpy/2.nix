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
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    hash = "sha256-SFuHI1eWQQw1GaaZz+H6qwl+UJ6Q67BdzQmNsq6H57M=";
  };

  patches = lib.optionals python.hasDistutilsCxxPatch [
    # We patch cpython/distutils to fix https://bugs.python.org/issue1222585
    # Patching of numpy.distutils is needed to prevent it from undoing the
    # patch to distutils.
    ./numpy-distutils-C++.patch
  ];

  postPatch = ''
    # remove needless reference to full Python path stored in built wheel
    substituteInPlace numpy/meson.build \
      --replace-fail 'py.full_path()' "'python'"
  '';

  build-system =
    [
      cython
      gfortran
      meson-python
      pkg-config
    ]
    ++ lib.optionals stdenv.isDarwin [ xcbuild.xcrun ]
    ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [ mesonEmulatorHook ];

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

  buildInputs = [
    blas
    lapack
  ];

  preBuild = ''
    ln -s ${cfg} site.cfg
  '';

  enableParallelBuilding = true;

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    pytest-xdist
    setuptools
    typing-extensions
  ];

  preCheck = ''
    pushd $out
  '';

  postCheck = ''
    popd
  '';

  # https://github.com/numpy/numpy/blob/a277f6210739c11028f281b8495faf7da298dbef/numpy/_pytesttester.py#L180
  pytestFlagsArray = [
    "-m"
    "not\\ slow" # fast test suite
  ];

  disabledTests =
    lib.optionals (pythonAtLeast "3.13") [
      # https://github.com/numpy/numpy/issues/26713
      "test_iter_refcount"
    ]
    ++ lib.optionals stdenv.isAarch32 [
      # https://github.com/numpy/numpy/issues/24548
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
    ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
      # AssertionError: (np.int64(0), np.longdouble('9.9999999999999994515e-21'), np.longdouble('3.9696755572509052902e+20'), 'arctanh')
      "test_loss_of_precision"
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

  meta = {
    changelog = "https://github.com/numpy/numpy/releases/tag/v${version}";
    description = "Scientific tools for Python";
    homepage = "https://numpy.org/";
    license = lib.licenses.bsd3;
  };
}
