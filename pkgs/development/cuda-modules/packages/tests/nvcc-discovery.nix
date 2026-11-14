{
  backendStdenv,
  cuda_cudart,
  cuda_nvcc,
  cudaNamePrefix,
  cudatoolkit,
  lib,
}:
let
  buildNvcc = cuda_nvcc.__spliced.buildHost or cuda_nvcc;
  buildBuildNvcc = cuda_nvcc.__spliced.buildBuild or cuda_nvcc;
  buildTargetNvcc = cuda_nvcc.__spliced.buildTarget or cuda_nvcc;
  compilerPrefix = nvcc: lib.getOutput nvcc.outputBin nvcc;
  test =
    name: attrs: buildCommand:
    backendStdenv.mkDerivation (
      attrs
      // {
        name = "${cudaNamePrefix}-tests-nvcc-discovery-${name}";
        strictDeps = attrs.strictDeps or true;
        __structuredAttrs = true;
        inherit buildCommand;
      }
    );
  libraryOnly =
    test "library-only"
      {
        buildInputs = [ cuda_cudart ];
        NVCC_PREPEND_FLAGS = [
          "--library-only"
          "--untouched"
        ];
        dontCompressCudaFatbins = true;
      }
      ''
        test -z "''${CUDACXX-}''${CUDAHOSTCXX-}''${NVCC_CCBIN-}''${CUDAToolkit_ROOT-}"
        test -z "''${NIX_CUDA_DONT_COMPRESS_FATBINS-}"
        test "''${#NVCC_PREPEND_FLAGS[@]}" = 2
        test "''${NVCC_PREPEND_FLAGS[1]}" = --untouched
        cat > runtime.cpp <<'CPP'
        #include <cuda_runtime.h>
        #include <cuda/std/type_traits>
        static_assert(cuda::std::is_integral<int>::value);
        int main() {
          int version = 0;
          return cudaRuntimeGetVersion(&version) != cudaSuccess;
        }
        CPP
        mkdir "$out"
        "$CXX" runtime.cpp -lcudart -o "$out/runtime"
      '';
  callerOverrides =
    test "caller-overrides"
      {
        nativeBuildInputs = [ cuda_nvcc ];
        env = {
          CUDACXX = "/caller/cuda-compiler";
          CUDAHOSTCXX = "/caller/host-compiler";
          CUDAToolkit_ROOT = "/caller/cuda-root";
          CUDA_BIN_PATH = "/caller/cuda-bin";
        };
        NVCC_PREPEND_FLAGS = [ "--caller-flag" ];
        dontCompressCudaFatbins = true;
      }
      ''
        test "$CUDACXX" = /caller/cuda-compiler
        test "$CUDAHOSTCXX" = /caller/host-compiler
        [[ ! -v NVCC_CCBIN ]]
        test "$CUDAToolkit_ROOT" = /caller/cuda-root
        test "$CUDA_BIN_PATH" = /caller/cuda-bin
        [[ "$(declare -p NVCC_PREPEND_FLAGS)" == 'declare -x '* ]]
        test "$NVCC_PREPEND_FLAGS" = --caller-flag
        test "$NIX_CUDA_DONT_COMPRESS_FATBINS" = 1
        touch "$out"
      '';
  ccbinOverride =
    test "ccbin-override"
      {
        nativeBuildInputs = [ cuda_nvcc ];
        env.NVCC_CCBIN = "/caller/host-compiler";
      }
      ''
        [[ -v CUDAHOSTCXX && -z $CUDAHOSTCXX ]]
        test "$NVCC_CCBIN" = /caller/host-compiler
        touch "$out"
      '';
  compilerOverride =
    test "compiler-override"
      {
        nativeBuildInputs = [ cuda_nvcc ];
        env.CUDACXX = "/caller/cuda-compiler";
      }
      ''
        test "$CUDACXX" = /caller/cuda-compiler
        [[ -v CUDAHOSTCXX && -z $CUDAHOSTCXX ]]
        [[ ! -v NVCC_CCBIN ]]
        touch "$out"
      '';
  nonStrict =
    test "non-strict"
      {
        strictDeps = false;
        nativeBuildInputs = [ cuda_nvcc ];
        buildInputs = [ cuda_cudart ];
      }
      ''
        test "$CUDACXX" = '${lib.getExe buildNvcc}'
        test -z "''${CUDACXX_FOR_BUILD-}''${CUDACXX_FOR_TARGET-}"
        test "$CUDAToolkit_ROOT" = '${compilerPrefix buildNvcc}'
        "$CUDACXX" --version
        touch "$out"
      '';
  aggregate =
    test "aggregate"
      {
        nativeBuildInputs = [ cudatoolkit ];
      }
      ''
        test "$CUDACXX" = '${lib.getExe buildNvcc}'
        test "$CUDAToolkit_ROOT" = '${compilerPrefix buildNvcc}'
        "$CUDACXX" --version
        touch "$out"
      '';
in
test "strict-roles"
  {
    depsBuildBuild = [ cuda_nvcc ];
    nativeBuildInputs = [ cuda_nvcc ];
    depsBuildTarget = [ cuda_nvcc ];
    depsHostHost = [ cuda_nvcc ];
    buildInputs = [
      cuda_nvcc
      cuda_cudart
    ];
    depsTargetTarget = [ cuda_nvcc ];
    passthru.tests = {
      inherit
        libraryOnly
        callerOverrides
        ccbinOverride
        compilerOverride
        nonStrict
        aggregate
        ;
    };
  }
  ''
    test "$CUDACXX_FOR_BUILD" = '${lib.getExe buildBuildNvcc}'
    test "$CUDACXX" = '${lib.getExe buildNvcc}'
    test "$CUDACXX_FOR_TARGET" = '${lib.getExe buildTargetNvcc}'
    test "$CUDAToolkit_ROOT" = '${compilerPrefix buildNvcc}'
    test "$CUDA_BIN_PATH" = '${compilerPrefix buildNvcc}/bin'
    test "$NVCC_PREPEND_FLAGS" = ""
    "$CUDACXX_FOR_BUILD" --version
    "$CUDACXX" --version
    "$CUDACXX_FOR_TARGET" --version
    touch "$out"
  ''
