{
  lib,
  fetchFromGitHub,
  stdenv,
  gitUpdater,
  testers,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xevd";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "mpeg5";
    repo = "xevd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MMqtgXEcIYLr5gyIpGj1p0aPiEW0zb6ZAQ+75kHhyxU=";
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
