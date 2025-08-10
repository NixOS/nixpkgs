{
  lib,
  config,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  addDriverRunpath,
  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
  cudaPackages,
  setuptools,
  ocl-icd,
  rocmPackages,
  pytestCheckHook,
  gpuctypes,
  testCudaRuntime ? false,
  testOpenclRuntime ? false,
  testRocmRuntime ? false,
}:
assert testCudaRuntime -> cudaSupport;
assert testRocmRuntime -> rocmSupport;

buildPythonPackage rec {
  pname = "gpuctypes";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "gpuctypes";
    owner = "tinygrad";
    tag = version;
    hash = "sha256-xUMvMBK1UhZaMZfik0Ia6+siyZGpCkBV+LTnQvzt/rw=";
  };

  patches = [
    (replaceVars ./0001-fix-dlopen-cuda.patch {
      inherit (addDriverRunpath) driverLink;
      libnvrtc =
        if cudaSupport then
          "${lib.getLib cudaPackages.cuda_nvrtc}/lib/libnvrtc.so"
        else
          "Please import nixpkgs with `config.cudaSupport = true`";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  postPatch = ''
    substituteInPlace gpuctypes/opencl.py \
      --replace "ctypes.util.find_library('OpenCL')" "'${ocl-icd}/lib/libOpenCL.so'"
  ''
  # hipGetDevicePropertiesR0600 is a symbol from rocm-6. We are currently at rocm-5.
  # We are not sure that this works. Remove when rocm gets updated to version 6.
  + lib.optionalString rocmSupport ''
    substituteInPlace gpuctypes/hip.py \
      --replace "/opt/rocm/lib/libamdhip64.so" "${rocmPackages.clr}/lib/libamdhip64.so" \
      --replace "/opt/rocm/lib/libhiprtc.so" "${rocmPackages.clr}/lib/libhiprtc.so" \
      --replace "hipGetDevicePropertiesR0600" "hipGetDeviceProperties"

    substituteInPlace gpuctypes/comgr.py \
      --replace "/opt/rocm/lib/libamd_comgr.so" "${rocmPackages.rocm-comgr}/lib/libamd_comgr.so"
  '';

  pythonImportsCheck = [ "gpuctypes" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths =
    lib.optionals (!testOpenclRuntime) [ "test/test_opencl.py" ]
    ++ lib.optionals (!rocmSupport) [ "test/test_hip.py" ]
    ++ lib.optionals (!cudaSupport) [ "test/test_cuda.py" ];

  # Require GPU access to run (not available in the sandbox)
  disabledTests =
    lib.optionals (!testCudaRuntime) [
      "TestCUDADevice"
    ]
    ++ lib.optionals (!testRocmRuntime) [
      "TestHIPDevice"
    ];

  pytestFlags = lib.optionals (testCudaRuntime || testOpenclRuntime || testRocmRuntime) [ "-v" ];

  # Running these tests requires special configuration on the builder.
  # e.g. https://github.com/NixOS/nixpkgs/pull/256230 implements a nix
  # pre-build hook which exposes the devices and the drivers in the sandbox
  # based on requiredSystemFeatures:
  requiredSystemFeatures =
    lib.optionals testCudaRuntime [ "cuda" ]
    ++ lib.optionals testOpenclRuntime [ "opencl" ]
    ++ lib.optionals testRocmRuntime [ "rocm" ];

  passthru.gpuChecks = {
    cuda = gpuctypes.override {
      cudaSupport = true;
      testCudaRuntime = true;
    };
    opencl = gpuctypes.override { testOpenclRuntime = true; };
    rocm = gpuctypes.override {
      rocmSupport = true;
      testRocmRuntime = true;
    };
  };

  preCheck = lib.optionalString (cudaSupport && !testCudaRuntime) ''
    addToSearchPath LD_LIBRARY_PATH ${lib.getLib cudaPackages.cuda_cudart}/lib/stubs
  '';

  # If neither rocmSupport or cudaSupport is enabled, no tests are selected
  dontUsePytestCheck = !(rocmSupport || cudaSupport) && (!testOpenclRuntime);

  meta = with lib; {
    description = "Ctypes wrappers for HIP, CUDA, and OpenCL";
    homepage = "https://github.com/tinygrad/gpuctypes";
    license = licenses.mit;
    maintainers = with maintainers; [
      GaetanLepage
      matthewcroughan
      wozeparrot
    ];
  };
}
