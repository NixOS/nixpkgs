{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  gitUpdater,
  stdenv,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xeve";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "mpeg5";
    repo = "xeve";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8jXntm/yFme9ZPImdW54jAr11hEsU1K+N5/7RLmITPs=";
  };

  patches =
    lib.optionals (!lib.versionOlder "0.5.0" finalAttrs.version) (
      builtins.map fetchpatch2 [
        {
          url = "https://github.com/mpeg5/xeve/commit/954ed6e0494cd2438fd15c717c0146e88e582b33.patch?full_index=1";
          hash = "sha256-//NtOUm1fqPFvOM955N6gF+QgmOdmuVunwx/3s/G/J8=";
        }
        {
          url = "https://github.com/mpeg5/xeve/commit/07a6f2a6d13dfaa0f73c3752f8cd802c251d8252.patch?full_index=1";
          hash = "sha256-P9J7Y9O/lb/MSa5oCfft7z764AbLBLZnMmrmPEZPcws=";
        }
        {
          url = "https://github.com/mpeg5/xeve/commit/0a0f3bd397161253b606bdbeaa518fbe019d24e1.patch?full_index=1";
          hash = "sha256-PoZpE64gWkTUS4Q+SK+DH1I1Ac0UEzwwnlvpYN16hsI=";
        }
        {
          url = "https://github.com/mpeg5/xeve/commit/e029f1619ecedbda152b8680641fa10eea9eeace.patch?full_index=1";
          hash = "sha256-ooIBzNtGSjDgYvTzA8T0KB+QzsUiy14mPpoRqrHF3Pg=";
        }
      ]
      ++ [
        # Backport to 0.5.0 of upstream patch c564ac77c103dbba472df3e13f4733691fd499ed
        ./0001-CMakeLists.txt-Disable-static-linking-on-Darwin.patch
      ]
    )
    ++ [
      # Rejected upstream, can be dropped when a fix for
      # https://github.com/mpeg5/xeve/pull/123 is in a version bump.
      ./0002-sse2neon-Cast-to-variable-type.patch
    ];

  postPatch = ''
    echo v$version > version.txt
  '';

  nativeBuildInputs = [ cmake ];

  cmakeFlags =
    let
      inherit (lib) cmakeBool cmakeFeature optional;
      inherit (stdenv.hostPlatform) isAarch64 isDarwin;
    in
    optional isAarch64 (cmakeBool "ARM" true)
    ++ optional isDarwin (cmakeFeature "CMAKE_SYSTEM_NAME" "Darwin");

  env.NIX_CFLAGS_COMPILE = builtins.toString (
    builtins.map (w: "-Wno-" + w) (
      [
        # Patch addressing an if without a body was rejected upstream, third
        # line-based comment in this thread, https://github.com/mpeg5/xeve/pull/122#pullrequestreview-2187744305
        # Evaluate on version bump whether still necessary.
        "empty-body"

        # Evaluate on version bump whether still necessary.
        "parentheses-equality"
        "unknown-warning-option"
      ]
      ++ (
        # Fixed upstream in 325fd9f94f3fdf0231fa931a31ebb72e63dc3498 but might
        # change behavior, therefore opted to leave it out for now.
        lib.optional (!lib.versionOlder "0.5.0" finalAttrs.version) "for-loop-analysis"
      )
    )
  );

  postInstall = ''
    ln $dev/include/xeve/* $dev/include/
  '';

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    homepage = "https://github.com/mpeg5/xeve";
    description = "eXtra-fast Essential Video Encoder, MPEG-5 EVC";
    license = lib.licenses.bsd3;
    mainProgram = "xeve_app";
    maintainers = with lib.maintainers; [ jopejoe1 ];
    platforms = lib.platforms.all;
    broken = stdenv.isLinux && stdenv.isAarch64;
  };
})
