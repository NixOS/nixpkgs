{
  lib,
  stdenv,
  pythonAtLeast,
  pythonOlder,
  fetchFromGitHub,
  python,
  buildPythonPackage,
  setuptools,
  numpy_2,
  llvmlite,
  libcxx,
  importlib-metadata,
  fetchpatch,
  substituteAll,
  runCommand,
  writers,
  numba,
  pytestCheckHook,

  config,

  # CUDA-only dependencies:
  addDriverRunpath,
  autoAddDriverRunpath,
  cudaPackages,

  # CUDA flags:
  cudaSupport ? config.cudaSupport,
  testsWithoutSandbox ? false,
  doFullCheck ? false,
}:

let
  cudatoolkit = cudaPackages.cuda_nvcc;
in
buildPythonPackage rec {
  version = "0.61.0dev0";
  pname = "numba";
  pyproject = true;

  disabled = pythonOlder "3.8" || pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "numba";
    repo = "numba";
    rev = "refs/tags/${version}";
    # Upstream uses .gitattributes to inject information about the revision
    # hash and the refname into `numba/_version.py`, see:
    #
    # - https://git-scm.com/docs/gitattributes#_export_subst and
    # - https://github.com/numba/numba/blame/5ef7c86f76a6e8cc90e9486487294e0c34024797/numba/_version.py#L25-L31
    #
    # Hence this hash may change if GitHub / Git will change it's behavior.
    # Hopefully this will not happen until the next release. We are fairly sure
    # that upstream relies on those strings to be valid, that's why we don't
    # use `forceFetchGit = true;`.` If in the future we'll observe the hash
    # changes too often, we can always use forceFetchGit, and inject the
    # relevant strings ourselves, using `substituteInPlace`, in postFetch.
    hash = "sha256-KF9YQ6/FIfUQTJCAMgfIqnb/D8mdMbCC/tJvfYlSkgI=";
    # TEMPORARY: The way upstream knows it's source version is explained above,
    # and without this upstream sets the version in ${python.sitePackages} as
    # 0.61.0dev0, which causes dependent packages fail to find a valid
    # version of numba.
    postFetch = ''
      substituteInPlace $out/numba/_version.py \
        --replace-fail \
          'git_refnames = " (tag: ${version})"' \
          'git_refnames = " (tag: 0.61.0, release0.61)"'
    '';
  };

  postPatch = ''
    substituteInPlace numba/cuda/cudadrv/driver.py \
      --replace-fail \
        "dldir = [" \
        "dldir = [ '${addDriverRunpath.driverLink}/lib', "
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-I${lib.getDev libcxx}/include/c++/v1";

  build-system = [
    setuptools
  ];

  nativeBuildInputs = lib.optionals cudaSupport [
    autoAddDriverRunpath
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    # Not propagating it, because it numba can work with either numpy_2 or numpy_1
    numpy_2
  ] ++ lib.optionals cudaSupport [ cudaPackages.cuda_cudart ];

  dependencies = [
    llvmlite
    setuptools
  ] ++ lib.optionals (pythonOlder "3.9") [ importlib-metadata ];

  patches =
    [
      (fetchpatch {
        # TODO Remove at the next release of numba (>0.60.0)
        # https://github.com/numba/numba/pull/9683
        name = "fix-numpy-2-0-1-compat";
        url = "https://github.com/numba/numba/commit/afb3d168efa713c235d1bb4586722ad6e5dbb0c1.patch";
        hash = "sha256-WB+XKxsF2r5ZdgW2Yrg9HutpgufBfk48i+5YLQnKLFY=";
      })
    ]
    ++ lib.optionals cudaSupport [
      (substituteAll {
        src = ./cuda_path.patch;
        cuda_toolkit_path = cudatoolkit;
        cuda_toolkit_lib_path = lib.getLib cudatoolkit;
      })
    ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
    # https://github.com/NixOS/nixpkgs/issues/255262
    cd $out
  '';

  pytestFlagsArray = lib.optionals (!doFullCheck) [
    # These are the most basic tests. Running all tests is too expensive, and
    # some of them fail (also differently on different platforms), so it will
    # be too hard to maintain such a `disabledTests` list.
    "${python.sitePackages}/numba/tests/test_usecases.py"
  ];

  disabledTestPaths = lib.optionals (!testsWithoutSandbox) [
    # See NOTE near passthru.tests.withoutSandbox
    "${python.sitePackages}/numba/cuda/tests"
  ];

  pythonImportsCheck = [ "numba" ];

  passthru.testers.cuda-detect =
    writers.writePython3Bin "numba-cuda-detect"
      { libraries = [ (numba.override { cudaSupport = true; }) ]; }
      ''
        from numba import cuda
        cuda.detect()
      '';
  passthru.tests = {
    # CONTRIBUTOR NOTE: numba also contains CUDA tests, though these cannot be run in
    # this sandbox environment. Consider building the derivation below with
    # --no-sandbox to get a view of how many tests succeed outside the sandbox.
    withoutSandbox = numba.override {
      doFullCheck = true;
      cudaSupport = true;
      testsWithoutSandbox = true;
    };
    withSandbox = numba.override {
      cudaSupport = false;
      doFullCheck = true;
      testsWithoutSandbox = false;
    };
  };

  meta = with lib; {
    description = "Compiling Python code using LLVM";
    homepage = "https://numba.pydata.org/";
    license = licenses.bsd2;
    mainProgram = "numba";
  };
}
