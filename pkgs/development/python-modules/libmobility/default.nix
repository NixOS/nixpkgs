{
  lib,
  config,
  buildPythonPackage,
  fetchFromGitHub,
  python,

  # build-system
  cmake,
  nanobind,
  setuptools,

  # nativeBuildInputs
  autoAddDriverRunpath,
  cudaPackages,

  # buildInputs
  blas,
  lapack,

  # dependencies
  numpy,
  scipy,

  # tests
  pytest-xdist,
  pytestCheckHook,

  # passthru
  libmobility,
}:
let
  uammd-src = fetchFromGitHub {
    owner = "RaulPPelaez";
    repo = "uammd";
    tag = "v3.0.1";
    hash = "sha256-/7ceXlA96dZQs1WzkV1OpRv61xa0Tdt5gFe17I0s1BI=";
  };
in
buildPythonPackage.override { stdenv = cudaPackages.backendStdenv; } (finalAttrs: {
  pname = "libmobility";
  version = "1.1.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "stochasticHydroTools";
    repo = "libMobility";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7jUpVR4bS9vkgeKN68of6VNZzGPlQMcRMBStQ+wFEx4=";
  };

  postPatch =
    # Various setup.py patches:
    # - Inject nix's cmakeFlags
    # - Patch install destination
    # - Don't let setuptools ship the `solvers/` directory as the package is
    #   already installed by cmake
    # - Patch the version
    ''
      substituteInPlace setup.py \
        --replace-fail \
          "cmake_args = [" \
          "cmake_args = [${lib.concatStringsSep "," (map (f: "'${f}'") finalAttrs.cmakeFlags)}," \
        --replace-fail \
          "sys.prefix" \
          'os.environ["out"]' \
        --replace-fail \
          "packages=find_packages()," \
          "packages=[]," \
        --replace-fail \
          'version = "0"' \
          'version = "${finalAttrs.version}"'
    ''
    # Upstream installs the modules into the (read-only) absolute `Python_SITEARCH`.
    # Make the destination relative so it lands under CMAKE_INSTALL_PREFIX ($out).
    + ''
      substituteInPlace solvers/CMakeLists.txt \
        --replace-fail "$""{Python_SITEARCH}" "${python.sitePackages}"
    ''
    # The C++ test suite unconditionally fetches googletest over the network and
    # is not run here (it requires a GPU); drop it.
    + ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "add_subdirectory(tests/cpp)" ""
    '';

  build-system = [
    cmake
    nanobind
    setuptools
  ];
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    autoAddDriverRunpath
    cudaPackages.cuda_nvcc
  ];

  cmakeFlags = [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_UAMMD" uammd-src.outPath)
    (lib.cmakeFeature "nanobind_DIR" "${nanobind}/${python.sitePackages}/nanobind/cmake")
  ];

  env = {
    CMAKE_CUDA_ARCHITECTURES = cudaPackages.flags.cmakeCudaArchitecturesString;
  };

  preBuild = ''
    export BUILD_JOBS="$NIX_BUILD_CORES"
  '';

  buildInputs = [
    blas
    lapack
  ]
  ++ (with cudaPackages; [
    cuda_cccl # <nv/target>
    cuda_cudart # CUDA::cuda_driver (driver stub)
    libcublas
    libcufft
    libcurand
    libcusolver
  ]);

  dependencies = [
    numpy
    scipy
  ];

  pythonImportsCheck = [ "libMobility" ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    # FileNotFoundError: [Errno 2] No such file or directory: './ref/pair_mobility_nbody_freespace.npz'
    "test_pair_mobility_angular_nbody"

    # AssertionError (numerical assertion)
    "test_deterministic_divM_matches_rfd"
    "test_non_square_box"

    # TypeError: Iterator operand 1 dtype could not be cast from dtype('complex128') to
    # dtype('float64') according to the rule 'safe'
    "test_fluctuation_dissipation_angular_displacements"

    # Extremely long
    "test_fluctuation_dissipation_linear_displacements"
  ];

  # Tests require GPU access
  doCheck = false;
  passthru.gpuCheck = libmobility.overridePythonAttrs {
    requiredSystemFeatures = [ "cuda" ];
    doCheck = true;
  };

  meta = {
    description = "Python interface to a collection of GPU hydrodynamic mobility solvers";
    homepage = "https://github.com/stochasticHydroTools/libMobility";
    changelog = "https://github.com/stochasticHydroTools/libMobility/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
    broken = !config.cudaSupport;
  };
})
