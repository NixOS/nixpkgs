{
  lib,
  fetchFromGitHub,
  gitUpdater,
  stdenv,
  testers,
  nasm,
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
    [
      "-Wno-incompatible-pointer-types"
    ]
    ++ lib.optionals (stdenv.cc.isClang || stdenv.cc.isZig) [
      "-Wno-incompatible-function-pointer-types"
    ]
  );

  postPatch = ''
    substituteInPlace ./version.sh \
      --replace-fail "date" 'date -ud "@$SOURCE_DATE_EPOCH"'
  '';

  preConfigure =
    ''
      # Generate version.h
      ./version.sh
      cd build/linux
    ''
    + lib.optionalString stdenv.hostPlatform.isx86 ''
      # `AS' is set to the binutils assembler, but we need nasm
      unset AS
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

  nativeBuildInputs = [
    nasm
  ];

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
    platforms = lib.platforms.x86;
  };
})
