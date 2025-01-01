{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  stdenv,
  gitUpdater,
  testers,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xevd";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "mpeg5";
    repo = "xevd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Dc2V77t+DrZo9252FAL0eczrmikrseU02ob2RLBdVvU=";
  };

  patches = lib.optionals (!lib.versionOlder "0.5.0" finalAttrs.version) (
    builtins.map fetchpatch2 [
      # Upstream accepted patches, should be dropped on next version bump.
      {
        url = "https://github.com/mpeg5/xevd/commit/7eda92a6ebb622189450f7b63cfd4dcd32fd6dff.patch?full_index=1";
        hash = "sha256-Ru7jGk1b+Id5x1zaiGb7YKZGTNaTcArZGYyHbJURfgs=";
      }
      {
        url = "https://github.com/mpeg5/xevd/commit/499bc0153a99f8c8fd00143dd81fc0d858a5b509.patch?full_index=1";
        hash = "sha256-3ExBNTeBhj/IBweYkgWZ2ZgUypFua4oSC24XXFmjxXA=";
      }
      {
        url = "https://github.com/mpeg5/xevd/commit/b099623a09c09cddfe7f732fb795b2af8a020620.patch?full_index=1";
        hash = "sha256-Ee/PQmsGpUCU7KUMbdGEXEEKOc8BHYcGF4mq+mmWb/w=";
      }
      {
        url = "https://github.com/mpeg5/xevd/commit/2e6b24bf1f946c30d789b114dfd56e91b99039fe.patch?full_index=1";
        hash = "sha256-thT0kVSKwWruyhIjDFBulyUNeyG9zQ8rQtpZVmRvYxI=";
      }
      {
        url = "https://github.com/mpeg5/xevd/commit/c1f23a41b8def84ab006a8ce4e9221b2fff84a1a.patch?full_index=1";
        hash = "sha256-MOJ9mU5txk6ISzJsQdK+TTb2dlWD8ofGZI0nfq9rsPo=";
      }
      {
        url = "https://github.com/mpeg5/xevd/commit/adf1c45d6edb0d235997a40261689d7454b711c5.patch?full_index=1";
        hash = "sha256-tGIPaswx9S1Oy8QF928RzV/AHr710kYxXfMRYg6SLR4=";
      }
    ]
  );

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
        # Evaluate on version bump whether still necessary.
        "sometimes-uninitialized"
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
    ln $dev/include/xevd/* $dev/include/
  '';

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };
  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    homepage = "https://github.com/mpeg5/xevd";
    description = "eXtra-fast Essential Video Decoder, MPEG-5 EVC";
    license = lib.licenses.bsd3;
    mainProgram = "xevd_app";
    pkgConfigModules = [ "xevd" ];
    maintainers = with lib.maintainers; [ jopejoe1 ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64;
  };
})
