{
  buildPackages,
  cudaConfig,
  cudaMajorMinorVersion,
  cudaNamePrefix,
  cuda_nvcc,
  lib,
  stdenvNoCC,
}:
let
  # Reuse the package's compatibility selection for a Clang backend. The
  # constructor and compiler must run on BUILD and emit for the consumer's HOST.
  cc =
    (buildPackages.callPackage ../../backend.nix {
      inherit cudaMajorMinorVersion;
      backendCC = cc;
      targetPackages = buildPackages.targetPackages // {
        stdenv = buildPackages.targetPackages.clangStdenv;
      };
    }).cc;
  nvcc = (cuda_nvcc.__spliced.buildHost or cuda_nvcc).override { backendCC = cc; };
  arch = lib.replaceStrings [ "." ] [ "" ] (lib.head cudaConfig.cudaCapabilities);
in
stdenvNoCC.mkDerivation {
  name = "${cudaNamePrefix}-tests-nvcc-fortify";
  strictDeps = true;
  buildCommand = ''
    mkdir "$out"
    cat > libc-headers.h <<'CUDA'
    // Exercise every glibc family using Clang's fortify overloads. CUDA 12's
    // linkage workaround must also preserve ordinary declarations and uses.
    #include <arpa/inet.h>
    #include <fcntl.h>
    #include <mqueue.h>
    #include <poll.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <sys/socket.h>
    #include <syslog.h>
    #include <unistd.h>
    #include <wchar.h>
    CUDA
    cat > check.cu <<'CUDA'
    #include "libc-headers.h"
    #if __USE_FORTIFY_LEVEL != 2
    #error Expected the standard Clang fortify level
    #endif
    char* (*strcpy_address)(char*, const char*) = &strcpy;
    void* (*memcpy_address)(void*, const void*, size_t) = &memcpy;
    int (*fprintf_address)(FILE*, const char*, ...) = &fprintf;
    extern "C" __global__ void saxpy(int n, float a, const float* x, float* y) {
      int i = blockIdx.x * blockDim.x + threadIdx.x;
      if (i < n) y[i] = a * x[i] + y[i];
    }
    int main(int argc, char** argv) {
      if (argc > 1 && argv[1][0] == 'n') {
        char format[] = "%n";
        int n = -1;
        fprintf(stdout, format, &n);
        return n;
      }
      char buffer[8];
      strcpy(buffer, argc > 1 ? argv[1] : "safe");
      fprintf(stdout, "%s\n", buffer);
      return 0;
    }
    CUDA
    # Installed/JIT invocations do not activate setup hooks. The packaged
    # compiler must provide its own backend, headers and fortify workaround.
    # Request hardening explicitly: outside stdenv it is caller policy.
    # cc-wrapper filters fortify3 to the supported level 2 for Clang.
    compile() {
      env -i HOME="$TMPDIR" TMPDIR="$TMPDIR" NIX_HARDENING_ENABLE=fortify3 \
        PATH=${
          lib.makeBinPath [
            buildPackages.coreutils
            buildPackages.bash
          ]
        } \
        ${lib.getExe nvcc} -O2 "$@"
    }
    # GNU inline wrappers must not introduce libc definitions in every TU.
    echo '#include "libc-headers.h"' > linkage.cu
    compile -arch=sm_${arch} -c linkage.cu -o linkage.o
    compile -arch=sm_${arch} --cudart=shared check.cu linkage.o -o "$out/check"
    compile -arch=compute_${arch} -ptx check.cu -o "$out/saxpy.ptx"
    ${lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
      ulimit -c 0
      test "$($out/check)" = safe
      # Compilation alone must not conceal weakened fortification. Both the
      # writable-format check and the destination-size check must still abort.
      for argument in n 0123456789abcdef; do
        status=0
        "$out/check" "$argument" > diagnostic 2>&1 || status=$?
        test "$status" = 134
        case "$argument" in
          n) grep -F '%n in writable segments detected' diagnostic ;;
          *) grep -F 'buffer overflow detected' diagnostic ;;
        esac
      done
    ''}
  '';
}
