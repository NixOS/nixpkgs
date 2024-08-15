{
  lib,
  stdenv,
  pythonAtLeast,
  pythonOlder,
  fetchFromGitHub,
  python,
  buildPythonPackage,
  setuptools,
  numpy,
  numpy_2,
  llvmlite,
  libcxx,
  importlib-metadata,
  substituteAll,
  runCommand,
  writers,
  numba,

  config,

  # CUDA-only dependencies:
  addDriverRunpath,
  autoAddDriverRunpath,
  cudaPackages,

  # CUDA flags:
  cudaSupport ? config.cudaSupport,
}:

let
  cudatoolkit = cudaPackages.cuda_nvcc;
in
buildPythonPackage rec {
  version = "0.60.0";
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
    # relevant strings ourselves, using `sed` commands, in extraPostFetch.
    hash = "sha256-hUL281wHLA7wo8umzBNhiGJikyIF2loCzjLECuC+pO0=";
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
    numpy_2
  ];

  nativeBuildInputs = lib.optionals cudaSupport [
    autoAddDriverRunpath
    cudaPackages.cuda_nvcc
  ];

  buildInputs = lib.optionals cudaSupport [ cudaPackages.cuda_cudart ];

  dependencies = [
    numpy
    llvmlite
    setuptools
  ] ++ lib.optionals (pythonOlder "3.9") [ importlib-metadata ];

  patches = lib.optionals cudaSupport [
    (substituteAll {
      src = ./cuda_path.patch;
      cuda_toolkit_path = cudatoolkit;
      cuda_toolkit_lib_path = lib.getLib cudatoolkit;
    })
  ];

  # run a smoke test in a temporary directory so that
  # a) Python picks up the installed library in $out instead of the build files
  # b) we have somewhere to put $HOME so some caching tests work
  # c) it doesn't take 6 CPU hours for the full suite
  checkPhase = ''
    runHook preCheck

    pushd $(mktemp -d)
    HOME=. ${python.interpreter} -m numba.runtests -m $NIX_BUILD_CORES numba.tests.test_usecases
    popd

    runHook postCheck
  '';

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
    # this sandbox environment. Consider running similar commands to those below outside the
    # sandbox manually if you have the appropriate hardware; support will be detected
    # and the corresponding tests enabled automatically.
    # Also, the full suite currently does not complete on anything but x86_64-linux.
    fullSuite = runCommand "${pname}-test" { } ''
      pushd $(mktemp -d)
      # pip and python in $PATH is needed for the test suite to pass fully
      PATH=${
        python.withPackages (p: [
          p.numba
          p.pip
        ])
      }/bin:$PATH
      HOME=$PWD python -m numba.runtests -m $NIX_BUILD_CORES
      popd
      touch $out # stop Nix from complaining no output was generated and failing the build
    '';
  };

  meta = with lib; {
    description = "Compiling Python code using LLVM";
    homepage = "https://numba.pydata.org/";
    license = licenses.bsd2;
    mainProgram = "numba";
  };
}
