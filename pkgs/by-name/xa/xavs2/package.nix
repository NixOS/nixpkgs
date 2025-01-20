{
  lib,
  fetchFromGitHub,
  gitUpdater,
  stdenv,
  testers,
  buildPackages,
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

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals (stdenv.cc.isClang || stdenv.cc.isZig) [
      "-Wno-incompatible-function-pointer-types"
    ]
  );

  postPatch = ''
    substituteInPlace ./version.sh \
      --replace-fail "date" 'date -ud "@$SOURCE_DATE_EPOCH"'
  '';

  preConfigure = ''
    # Generate version.h
    ./version.sh
    cd build/linux

     # When setting this over `env.AS` it gets ignored
    export AS=${lib.getExe buildPackages.nasm}
  '';

  configureFlags =
    [ "--cross-prefix=${stdenv.cc.targetPrefix}" ]
    ++ lib.optionals (!stdenv.hostPlatform.isStatic) [
      (lib.enableFeature true "shared")
      "--system-libxavs2"
    ];

  postInstall = lib.optionalString (!stdenv.hostPlatform.isStatic) ''
    rm $lib/lib/*.a
  '';

  outputs = [
    "out"
    "lib"
    "dev"
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
