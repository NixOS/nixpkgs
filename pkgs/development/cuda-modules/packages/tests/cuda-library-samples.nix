{
  addDriverRunpath,
  autoAddDriverRunpath,
  autoPatchelfHook,
  backendStdenv,
  cmake,
  cuda_cccl,
  cuda_cudart,
  cuda_nvcc,
  cudatoolkit,
  libcusparse_lt,
  libcutensor,
  fetchFromGitHub,
  lib,
  libcusparse,
  setupCudaHook,
}:
let
  base = backendStdenv.mkDerivation (finalAttrs: {
    src = fetchFromGitHub {
      owner = "NVIDIA";
      repo = "CUDALibrarySamples";
      rev = "e57b9c483c5384b7b97b7d129457e5a9bdcdb5e1";
      sha256 = "0g17afsmb8am0darxchqgjz1lmkaihmnn7k1x4ahg5gllcmw8k3l";
    };
    version =
      lib.strings.substring 0 7 finalAttrs.src.rev + "-" + lib.versions.majorMinor cudatoolkit.version;
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
      maintainers = with lib.maintainers; [ obsidian-systems-maintenance ];
      teams = [ lib.teams.cuda ];
    };
  });
in

{
  cublas = base.overrideAttrs (
    finalAttrs: _: {
      pname = "cuda-library-samples-cublas";
      sourceRoot = "${finalAttrs.src.name}/cuBLASLt";
    }
  );

  cusolver = base.overrideAttrs (
    finalAttrs: _: {
      pname = "cuda-library-samples-cusolver";
      sourceRoot = "${finalAttrs.src.name}/cuSOLVER/gesv";
    }
  );

  cutensor = base.overrideAttrs (
    finalAttrs: prevAttrs: {
      pname = "cuda-library-samples-cutensor";

      sourceRoot = "${finalAttrs.src.name}/cuTENSOR";

      buildInputs = prevAttrs.buildInputs or [ ] ++ [ libcutensor ];

      cmakeFlags = prevAttrs.cmakeFlags or [ ] ++ [
        "-DCUTENSOR_EXAMPLE_BINARY_INSTALL_DIR=${placeholder "out"}/bin"
      ];

      # CUTENSOR_ROOT is double escaped
      postPatch = prevAttrs.postPatch or "" + ''
        substituteInPlace CMakeLists.txt \
          --replace-fail "\''${CUTENSOR_ROOT}/include" "${lib.getOutput "include" libcutensor}/include"
      '';

      CUTENSOR_ROOT = libcutensor;
    }
  );

  cusparselt = base.overrideAttrs (
    finalAttrs: prevAttrs: {
      pname = "cuda-library-samples-cusparselt";

      sourceRoot = "${finalAttrs.src.name}/cuSPARSELt/matmul";

      nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [
        cmake
        addDriverRunpath
        (lib.getDev libcusparse_lt)
        (lib.getDev libcusparse)
        cuda_nvcc
        (lib.getDev cuda_cudart) # <cuda_runtime_api.h>
        cuda_cccl # <nv/target>
      ];

      postPatch = prevAttrs.postPatch or "" + ''
        substituteInPlace CMakeLists.txt \
          --replace-fail "''${CUSPARSELT_ROOT}/lib64/libcusparseLt.so" "${lib.getLib libcusparse_lt}/lib/libcusparseLt.so" \
          --replace-fail "''${CUSPARSELT_ROOT}/lib64/libcusparseLt_static.a" "${lib.getStatic libcusparse_lt}/lib/libcusparseLt_static.a"
      '';

      postInstall = prevAttrs.postInstall or "" + ''
        mkdir -p $out/bin
        cp matmul_example $out/bin/
        cp matmul_example_static $out/bin/
      '';

      CUDA_TOOLKIT_PATH = lib.getLib cudatoolkit;
      CUSPARSELT_PATH = lib.getLib libcusparse_lt;
    }
  );
}
