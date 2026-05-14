{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  replaceVars,
  fetchpatch,

  # nativeBuildInputs
  setuptools,

  # dependencies
  llvmlite,
  numpy,

  # tests
  numba,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  numpy_1,
  writers,
  python,

  # CUDA-only dependencies:
  addDriverRunpath,
  autoAddDriverRunpath,
  cudaPackages,

  # CUDA flags:
  config,
  cudaSupport ? config.cudaSupport,
  testsWithoutSandbox ? false,
  doFullCheck ? false,
}:

let
  cudatoolkit = cudaPackages.cuda_nvcc;
in
buildPythonPackage (finalAttrs: {
  version = "0.63.1";
  pname = "numba";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "numba";
    repo = "numba";
    tag = finalAttrs.version;
    # Upstream uses .gitattributes to inject information about the revision
    # hash and the refname into `numba/_version.py`, see:
    #
    # - https://git-scm.com/docs/gitattributes#_export_subst and
    # - https://github.com/numba/numba/blame/5ef7c86f76a6e8cc90e9486487294e0c34024797/numba/_version.py#L25-L31
    postFetch = ''
      sed -i 's/git_refnames = "[^"]*"/git_refnames = " (tag: ${finalAttrs.src.tag})"/' $out/numba/_version.py
    '';
    hash = "sha256-M7Hdc1Qakclz7i/HujBUqVEWFsHj9ZGQDzb8Ze9AztA=";
  };

  postPatch = ''
    substituteInPlace numba/cuda/cudadrv/driver.py \
      --replace-fail \
        "dldir = [" \
        "dldir = [ '${addDriverRunpath.driverLink}/lib', "
  '';

  build-system = [
    setuptools
    numpy
  ];

  nativeBuildInputs = lib.optionals cudaSupport [
    autoAddDriverRunpath
    cudaPackages.cuda_nvcc
  ];

  buildInputs = lib.optionals cudaSupport [ cudaPackages.cuda_cudart ];

  pythonRelaxDeps = [
    "numpy"
  ];

  dependencies = [
    numpy
    llvmlite
  ];

  patches = [
    # Support Numpy 2.4, see:
    #
    # - https://github.com/numba/numba/pull/10393
    # - https://github.com/numba/numba/issues/10263
    (fetchpatch {
      url = "https://github.com/numba/numba/commit/7ec267efb80d87f0652c00535e8843f35d006f20.patch";
      hash = "sha256-oAOZa2/m2qs8CeX13/0lmRTg/lQj5aDIaaQeDeLAghc=";
      excludes = [
        "azure-pipelines.yml"
        "buildscripts/azure/azure-windows.yml"
      ];
    })
    # The above doesn't fix the source's build and run time checks of Numpy's
    # version, it only fixes the tests and API. Upstream puts these checks only
    # in release tarballs, and hence the patch has to be vendored.
    ./numpy2.4.patch
  ]
  ++ lib.optionals cudaSupport [
    (replaceVars ./cuda_path.patch {
      cuda_toolkit_path = cudatoolkit;
      cuda_toolkit_lib_path = lib.getLib cudatoolkit;
    })
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  # https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = ''
    cd $out
  '';

  enabledTestPaths =
    if doFullCheck then
      null
    else
      [
        # These are the most basic tests. Running all tests is too expensive, and
        # some of them fail (also differently on different platforms), so it will
        # be too hard to maintain such a `disabledTests` list.
        "${python.sitePackages}/numba/tests/test_usecases.py"
      ];

  disabledTests = lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # captured stderr: Fatal Python error: Segmentation fault
    "test_sum1d_pyobj"
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
    numpy_1 = numba.override {
      numpy = numpy_1;
    };
  };

  meta = {
    changelog = "https://numba.readthedocs.io/en/stable/release/${finalAttrs.version}-notes.html";
    description = "Compiling Python code using LLVM";
    homepage = "https://numba.pydata.org/";
    license = lib.licenses.bsd2;
    mainProgram = "numba";
  };
})
