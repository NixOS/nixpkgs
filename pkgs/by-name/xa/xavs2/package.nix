{
  lib,
  fetchFromGitHub,
  gitUpdater,
  nasm,
  stdenv,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xavs2";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "pkuvcl";
    repo = "xavs2";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-4w/WTXvRQbohKL+YALQCCYglHQKVvehlUYfitX/lLPw=";
  };

  env.NIX_CFLAGS_COMPILE = toString [
    # Fixes compile error on darwin
    "-Wno-incompatible-function-pointer-types"
  ];

  preConfigure = ''
    ./version.sh
    cd build/linux
    export AS=nasm
  '';

  configureFlags = [
    (lib.enableFeature (!stdenv.hostPlatform.isStatic) "shared")
    "--system-libxavs2"
  ];

  postInstall =
    if (!stdenv.hostPlatform.isStatic) then
      ''
        rm $lib/lib/*.a
      ''
    else
      "";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  nativeBuildInputs = [
    nasm
    validatePkgConfig
  ];

  passthru = {
    updateScript = gitUpdater { };
    tests.pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
  };

  meta = {
    homepage = "https://github.com/pkuvcl/xavs2";
    description = "Open-source encoder of AVS2-P2/IEEE1857.4 video coding standard";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xavs2";
    pkgConfigModules = [ "xavs2" ];
    maintainers = with lib.maintainers; [ jopejoe1 ];
    platforms = lib.platforms.all;
  };
})
