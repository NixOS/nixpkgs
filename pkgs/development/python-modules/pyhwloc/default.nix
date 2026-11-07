{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  autoconf,
  automake,
  libtool,

  cmake,
  hatchling,
  packaging,

  pytestCheckHook,

  config,
  enableCuda ? config.cudaSupport,
  cudaPackages,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyhwloc";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "open-mpi";
    repo = "pyhwloc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aGtwPIOISmx5KHKc40FTQvS0PbIvsYSiqdOxZgrJ+xc=";
  };

  hwloc_3_src = fetchFromGitHub {
    owner = "open-mpi";
    repo = "hwloc";
    rev = "a8102be90a41b84eee07783b8687098653842894";
    hash = "sha256-vFsPzTfcr2BeVSrvp1mqg42nm8l7MlmytvvlU5TGQes=";
  };

  patches = [
    # the config wants to install pyhwloc.so multiple times and to the wrong location
    ./dedup-libs.patch
  ];

  dontUseCmakeConfigure = true;

  env = {
    PYHWLOC_FETCH_HWLOC = "True";
    PYHWLOC_WITH_CUDA = if enableCuda then "True" else "False";
  };

  preConfigure = ''
    used_rev="${finalAttrs.hwloc_3_src.rev}"
    expected_rev="$(cat dev/hwloc_version)"
    if [ "$used_rev" != "$expected_rev" ]; then
      echo "hwloc src revision is out of date! Should be '$expected_rev'"
      exit 1
    fi

    # the directory needs to be writable and autogen.sh needs to be runnable via a shebang
    cp -r "$hwloc_3_src" ./hwloc-src
    chmod -R +w ./hwloc-src
    patchShebangs hwloc-src/autogen.sh
    export PYHWLOC_HWLOC_SRC_DIR="$(pwd)/hwloc-src"
  '';

  # Note:
  # Some features are only present when compiling with hwloc 3.x.x
  # At the point of packaging hwloc has not made an actual 3.x.x release
  # Once it's released and the hwloc package inside nixpkgs is updated,
  # we can use that instead of rebuilding hwloc inside this derivation
  # The following patch will be needed for a prebuilt hwloc to work properly with pyhwloc:
  /*
    postPatch = ''
      substituteInPlace src/pyhwloc/hwloc/lib.py --replace-fail \
        'find_library(_get_libname("hwloc"))' \
        'os.path.join("${lib.getLib hwloc}", "lib", _get_libname("hwloc"))'
    '';
  */

  nativeBuildInputs = [
    # needed for running hwloc-src/autogen.sh
    autoconf
    automake
    libtool
  ]
  ++ lib.optionals enableCuda [
    cudaPackages.cuda_nvcc
  ];

  build-system = [
    cmake
    hatchling
    packaging
  ];

  buildInputs = lib.optionals enableCuda [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvml_dev
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # hwloc/linux: failed to find sysfs cpu topology directory, aborting linux discovery.
    "tests/test_topology.py::test_get_nbobjs_by_type_with_filter"
    "tests/test_hwloc/test_core.py::test_get_root_obj"
  ];

  pythonImportsCheck = [
    "pyhwloc"
  ];

  meta = {
    description = "Python bindings for hwloc";
    homepage = "https://github.com/open-mpi/pyhwloc";
    changelog = "https://github.com/open-mpi/pyhwloc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
})
