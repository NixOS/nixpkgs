{
  lib,
  backendStdenv,
  fetchFromGitHub,
  cmake,
  addDriverRunpath,
  autoAddDriverRunpath,
  cudatoolkit,
  cutensor,
  cusparselt,
  cudaPackages,
  setupCudaHook,
  autoPatchelfHook,
}:

let
  inherit (cudaPackages)
    cuda_cccl
    cuda_cudart
    cuda_nvcc
    libcusparse
    cudaAtLeast
    cudaOlder
    ;
  rev = "e57b9c483c5384b7b97b7d129457e5a9bdcdb5e1";
  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "CUDALibrarySamples";
    inherit rev;
    sha256 = "0g17afsmb8am0darxchqgjz1lmkaihmnn7k1x4ahg5gllcmw8k3l";
  };
  commonAttrs = {
    version = lib.strings.substring 0 7 rev + "-" + lib.versions.majorMinor cudatoolkit.version;
    nativeBuildInputs = [
      cmake
      addDriverRunpath
    ];
    buildInputs = [ cudatoolkit ];
    postFixup = ''
      for exe in $out/bin/*; do
        addDriverRunpath $exe
      done
    '';
    meta = {
      description = "examples of using libraries using CUDA";
      longDescription = ''
        CUDA Library Samples contains examples demonstrating the use of
        features in the math and image processing libraries cuBLAS, cuTENSOR,
        cuSPARSE, cuSOLVER, cuFFT, cuRAND, NPP and nvJPEG.
      '';
      license = lib.licenses.bsd3;
      platforms = [ "x86_64-linux" ];
      maintainers = with lib.maintainers; [ obsidian-systems-maintenance ] ++ lib.teams.cuda.members;
    };
  };
in

{
  cublas = backendStdenv.mkDerivation (
    commonAttrs
    // {
      pname = "cuda-library-samples-cublas";

      src = "${src}/cuBLASLt";
    }
  );

  cusolver = backendStdenv.mkDerivation (
    commonAttrs
    // {
      pname = "cuda-library-samples-cusolver";

      src = "${src}/cuSOLVER";

      sourceRoot = "cuSOLVER/gesv";
    }
  );

  cutensor = backendStdenv.mkDerivation (
    commonAttrs
    // {
      pname = "cuda-library-samples-cutensor";

      src = "${src}/cuTENSOR";

      buildInputs = [ cutensor ];

      cmakeFlags = [ "-DCUTENSOR_EXAMPLE_BINARY_INSTALL_DIR=${builtins.placeholder "out"}/bin" ];

      # CUTENSOR_ROOT is double escaped
      postPatch = ''
        substituteInPlace CMakeLists.txt \
          --replace-fail "\''${CUTENSOR_ROOT}/include" "${cutensor.dev}/include"
      '';

      CUTENSOR_ROOT = cutensor;
    }
  );

  cusparselt = backendStdenv.mkDerivation (
    commonAttrs
    // {
      pname = "cuda-library-samples-cusparselt";

      src = "${src}/cuSPARSELt";

      sourceRoot = "cuSPARSELt/matmul";

      buildInputs = lib.optionals (cudaOlder "11.4") [ cudatoolkit ];

      nativeBuildInputs =
        [
          cmake
          addDriverRunpath
          (lib.getDev cusparselt)
          (lib.getDev libcusparse)
        ]
        ++ lib.optionals (cudaOlder "11.4") [ cudatoolkit ]
        ++ lib.optionals (cudaAtLeast "11.4") [
          cuda_nvcc
          (lib.getDev cuda_cudart) # <cuda_runtime_api.h>
        ]
        ++ lib.optionals (cudaAtLeast "12.0") [
          cuda_cccl # <nv/target>
        ];

      postPatch = ''
        substituteInPlace CMakeLists.txt \
          --replace-fail "''${CUSPARSELT_ROOT}/lib64/libcusparseLt.so" "${lib.getLib cusparselt}/lib/libcusparseLt.so" \
          --replace-fail "''${CUSPARSELT_ROOT}/lib64/libcusparseLt_static.a" "${lib.getStatic cusparselt}/lib/libcusparseLt_static.a"
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        cp matmul_example $out/bin/
        cp matmul_example_static $out/bin/
        runHook postInstall
      '';

      CUDA_TOOLKIT_PATH = lib.getLib cudatoolkit;
      CUSPARSELT_PATH = lib.getLib cusparselt;
    }
  );
}
