{
  buildPackages,
  cudaMajorMinorVersion,
  cudaNamePrefix,
  lib,
  stdenvNoCC,
}:
let
  # Reuse nvcc-fortify's Clang selection without requiring NVIDIA binaries.
  # The compiler runs on BUILD and its builtin headers describe HOST.
  cc =
    (buildPackages.callPackage ../../backend.nix {
      inherit cudaMajorMinorVersion;
      backendCC = cc;
      targetPackages = buildPackages.targetPackages // {
        stdenv = buildPackages.targetPackages.clangStdenv;
      };
    }).cc;
in
stdenvNoCC.mkDerivation {
  name = "${cudaNamePrefix}-tests-backend-headers";
  strictDeps = true;
  buildCommand = ''
    ${import ../../test-support.nix { inherit buildPackages lib; }}
    cat > standard.c <<'C'
    #include <stddef.h>
    #include <stdint.h>
    #include <stdarg.h>
    #include <stdatomic.h>
    _Static_assert(sizeof(uint64_t) == 8, "uint64_t width");
    int load_value(atomic_int *value) { return atomic_load(value); }
    C
    cat > intrinsics.c <<'C'
    ${lib.optionalString stdenvNoCC.hostPlatform.isx86_64 ''
      #include <immintrin.h>
      __m128i add(__m128i a, __m128i b) { return _mm_add_epi32(a, b); }
    ''}
    ${lib.optionalString stdenvNoCC.hostPlatform.isAarch64 ''
      #include <arm_neon.h>
      int32x4_t add(int32x4_t a, int32x4_t b) { return vaddq_s32(a, b); }
    ''}
    C
    # Freestanding mode exercises Clang's own stdint definitions. Hosted mode
    # may use libc's replacement and conceal a frontend/header mismatch.
    for source in standard.c intrinsics.c; do
      runStandalone ${cc}/bin/${cc.targetPrefix}cc \
        -std=c17 -ffreestanding -fsyntax-only "$source"
    done
    touch "$out"
  '';
  passthru.backendCC = cc;
}
