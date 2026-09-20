{
  buildPackages,
  cccl,
  cudaConfig,
  cuda_crt,
  cuda_cudart,
  cuda_nvcc,
  cudaNamePrefix,
  cudaOlder,
  lib,
  libnvptxcompiler,
  stdenvNoCC,
}:
let
  # These are data for the emitted program, hence this consumer's HOST.
  mapped =
    package:
    (package.__spliced.hostHost or package).overrideAttrs (old: {
      outputs = [
        "out"
        "bin"
      ];
      outputDev = "bin";
      outputInclude = "bin";
      outputLib = "bin";
      outputStatic = "bin";
      outputStubs = "bin";
      passthru = old.passthru // {
        outputToPatterns = old.passthru.outputToPatterns // {
          bin = [ "*" ];
        };
      };
    });
  crt = mapped cuda_crt;
  headers = mapped cccl;
  runtime = (mapped cuda_cudart).override {
    cuda_crt = crt;
    cccl = headers;
  };
  runtimeWithStubs = runtime.overrideAttrs (old: {
    outputs = [
      "out"
      "stubs"
      "bin"
    ];
    outputStubs = "stubs";
    passthru = old.passthru // {
      outputToPatterns = old.passthru.outputToPatterns // {
        bin = [
          "include"
          "lib/*.a"
          "lib/*.so*"
          "share"
          "LICENSE"
        ];
      };
    };
  });
  nvcc = (cuda_nvcc.__spliced.buildHost or cuda_nvcc).override {
    cuda_crt = crt;
    cccl = headers;
    cuda_cudart = runtimeWithStubs;
    libnvptxcompiler = (mapped libnvptxcompiler).overrideAttrs (old: {
      outputs = [
        "out"
        "static"
        "bin"
      ];
      outputStatic = "static";
      passthru = old.passthru // {
        outputToPatterns = old.passthru.outputToPatterns // {
          bin = [
            "include"
            "LICENSE"
          ];
        };
      };
    });
  };
  arch = lib.replaceStrings [ "." ] [ "" ] (lib.head cudaConfig.cudaCapabilities);
in
stdenvNoCC.mkDerivation {
  name = "${cudaNamePrefix}-tests-nvcc-data-outputs";
  strictDeps = true;
  buildCommand = ''
    mkdir "$out"
    test -f '${lib.getInclude nvcc}/include/crt/host_config.h'
    cat > saxpy.cu <<'CUDA'
    #include <cuda_runtime.h>
    #include <cuda/std/type_traits>
    #if __CUDACC_VER_MAJOR__ < 13
    #include <nvPTXCompiler.h>
    #endif
    static_assert(cuda::std::is_integral_v<int>);
    extern "C" int cuInit(unsigned int);
    __global__ void saxpy(float a, const float* x, float* y) {
      int i = threadIdx.x;
      y[i] = a * x[i] + y[i];
    }
    int main() {
      int result = cuInit(0) + cudaDeviceSynchronize();
    #if __CUDACC_VER_MAJOR__ < 13
      unsigned int major, minor;
      result += nvPTXCompilerGetVersion(&major, &minor);
    #endif
      return result;
    }
    CUDA
    # The installed compiler's profile must locate its mapped TARGET inputs
    # without setup hooks supplying any header or library search paths.
    env -i HOME="$TMPDIR" TMPDIR="$TMPDIR" \
      PATH=${
        lib.makeBinPath [
          buildPackages.coreutils
          buildPackages.bash
        ]
      } \
      ${lib.getExe nvcc} -arch=sm_${arch} --cudart=shared saxpy.cu -lcuda \
        ${lib.optionalString (cudaOlder "13.0") "-L${lib.getOutput nvcc.outputLib nvcc}/lib -lnvptxcompiler_static"} \
        -o "$out/check"
  '';
}
