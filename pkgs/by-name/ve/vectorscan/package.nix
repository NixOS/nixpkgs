{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ragel,
  util-linux,
  python3,
  boost,
  simde,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableSimde ? lib.meta.availableOn stdenv.hostPlatform simde,
}:
let
  inherit (stdenv.hostPlatform)
    isx86
    isAarch64
    isLinux
    avx512Support
    avx2Support
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vectorscan";
  version = "5.4.14";

  src = fetchFromGitHub {
    owner = "VectorCamp";
    repo = "vectorscan";
    rev = "vectorscan/${finalAttrs.version}";
    hash = "sha256-v4i8SkcSwqj19Po6TL4093vrhe94pchad/GMw11rSMw=";
  };

  postPatch = ''
    sed -i '/examples/d' CMakeLists.txt
    substituteInPlace libhs.pc.in \
      --replace-fail "libdir=@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_LIBDIR@" "libdir=@CMAKE_INSTALL_LIBDIR@" \
      --replace-fail "includedir=@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_INCLUDEDIR@" "includedir=@CMAKE_INSTALL_INCLUDEDIR@"
    substituteInPlace cmake/cflags-generic.cmake \
      --replace-fail "-Werror" ""
  '';

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    ragel
    python3
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux util-linux;

  buildInputs = [
    boost
  ]
  ++ lib.optionals enableSimde [ simde ];

  # FAT_RUNTIME bundles optimized implementations for different CPU extensions and uses CPUID to
  # transparently select the fastest for the current hardware.
  # This feature is only available on linux for x86, x86_64, and aarch64.
  #
  # If FAT_RUNTIME is not available, we fall back to building for a single extension based
  # on stdenv.hostPlatform.
  #
  # For generic builds (e.g. x86_64) this can mean using an implementation not optimized for the
  # potentially available more modern hardware extensions (e.g. x86_64 with AVX512).
  cmakeFlags =
    let
      isx86Linux = isLinux && isx86;
      isArmLinux = isLinux && isAarch64;
    in
    [
      # Whenever avaliable enable SIMDE since there's no overheard, and will generally increase performance across
      # platforms.
      (lib.cmakeBool "SIMDE_BACKEND" enableSimde)
      # Nixpkgs doesn't care about benches
      (lib.cmakeBool "BUILD_BENCHMARKS" false)
      (lib.cmakeBool "BUILD_SHARED_LIBS" enableShared)
      (lib.cmakeBool "BUILD_STATIC_LIBS" (!enableShared))
      # On linux we will always build avx2 into the fat runtime.
      (lib.cmakeBool "BUILD_AVX2" (avx2Support || isx86Linux))
      (lib.cmakeBool "BUILD_AVX512" (avx512Support || isx86Linux))
      (lib.cmakeBool "BUILD_AVX512VBMI" (avx512Support || isx86Linux))
      # SIMD-everywhere supports SVE (mostly), but not SVE2
      # SVE is not natively supported on Apple silicon.
      (lib.cmakeBool "BUILD_SVE" isArmLinux)
      (lib.cmakeBool "BUILD_SVE2" isArmLinux)
      (lib.cmakeBool "BUILD_SVE2_BITPERM" isArmLinux)
      # Not supported on Apple silicon.
      (lib.cmakeBool "FAT_RUNTIME" (isArmLinux || isx86Linux))
    ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    ./bin/unit-hyperscan

    runHook postCheck
  '';

  meta = {
    description = "Portable fork of the high-performance regular expression matching library";
    longDescription = ''
      A fork of Intel's Hyperscan, modified to run on more platforms. Currently
      ARM NEON/ASIMD is 100% functional, and Power VSX are in development.
      ARM SVE2 will be implemented when hardware becomes accessible to the
      developers. More platforms will follow in the future, on demand/request.

      Vectorscan will follow Intel's API and internal algorithms where possible,
      but will not hesitate to make code changes where it is thought of giving
      better performance or better portability. In addition, the code will be
      gradually simplified and made more uniform and all architecture specific
      code will be abstracted away.
    '';
    homepage = "https://www.vectorcamp.gr/vectorscan/";
    changelog = "https://github.com/VectorCamp/vectorscan/blob/${finalAttrs.src.rev}/CHANGELOG-vectorscan.md";
    platforms = lib.platforms.unix;
    license =
      with lib.licenses;
      AND [
        bsd3
        bsd2
        lib.licenses.boost
      ];
    maintainers = with lib.maintainers; [
      tnias
      vlaci
    ];
  };
})
