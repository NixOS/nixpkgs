{
  lib,
  fetchFromGitHub,
  gitUpdater,
  stdenv,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xeve";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "mpeg5";
    repo = "xeve";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QA9+0PsPyg3gQYR2TpIO1nwL5H/BFpOtCX8xBQ4Qjmg=";
  };

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
    broken = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64;
  };
})
