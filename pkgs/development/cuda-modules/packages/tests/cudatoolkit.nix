{
  cudatoolkit,
  cuda_nvcc,
  cudaNamePrefix,
  lib,
  stdenv,
  tests,
}:
let
  # Select before overriding: an override of one derivation does not override
  # all its splices. Keep the compilation test small; component-hook tests the
  # full aggregate's discovery and propagation separately.
  compiler = (cudatoolkit.__spliced.buildHost or cudatoolkit).override (
    lib.genAttrs [
      "cuda_cuobjdump"
      "cuda_cupti"
      "cuda_cuxxfilt"
      "cuda_gdb"
      "cuda_nvdisasm"
      "cuda_nvml_dev"
      "cuda_nvprune"
      "cuda_nvrtc"
      "cuda_nvtx"
      "cuda_profiler_api"
      "cuda_sanitizer_api"
      "libcublas"
      "libcufft"
      "libcurand"
      "libcusolver"
      "libcusparse"
      "libnpp"
    ] (_: null)
  );
in
# The compiler must work without activating any setup hooks. Its library
# output must also be usable independently of its executable prefix.
(tests.nvcc-runtime.override { cuda_nvcc = compiler; }).overrideAttrs (old: {
  name = "${cudaNamePrefix}-tests-cudatoolkit";
  disallowedRequisites = [
    (lib.getBin (cuda_nvcc.__spliced.buildHost or cuda_nvcc))
    (lib.getBin (cuda_nvcc.__spliced.targetTarget or cuda_nvcc))
  ];
  buildCommand =
    old.buildCommand
    + ''
      ln -s ${compiler.lib} "$out/sdk"
      # SAXPY does not link libnvptxcompiler. In CUDA 12 it was bundled with
      # HOST's NVCC, so a successful CUDA compilation could hide a wrong-CPU
      # library in the merged toolkit. Exercise its CPU ABI separately.
      cat > ptx-version.cpp <<'CXX'
      #include <nvPTXCompiler.h>
      #include <cstdio>
      int main() {
        unsigned int major, minor;
        auto status = nvPTXCompilerGetVersion(&major, &minor);
        if (status != NVPTXCOMPILE_SUCCESS) return 1;
        printf("PTX compiler API: %u.%u\n", major, minor);
        return 0;
      }
      CXX
      compile -I${compiler.lib}/include -L${compiler.lib}/lib \
        ptx-version.cpp -lnvptxcompiler_static -o "$out/ptx-version"
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      "$out/ptx-version"
    '';
})
