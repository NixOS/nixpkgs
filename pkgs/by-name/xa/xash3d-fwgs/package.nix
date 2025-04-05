{
  lib,
  config,
  fetchFromGitHub,
  stdenv,
  ensureNewerSourcesForZipFilesHook,
  python3,
  pkg-config,
  wafHook,
  SDL2,
  freetype,
  opusfile,
  libopus,
  libogg,
  libvorbis,
  bzip2,
  xash-sdk,
  makeWrapper,

  # Options
  buildXashSdk ? true,
}:

stdenv.mkDerivation {
  pname = "xash3d-fwgs";
  version = "0-unstable-2025-02-23";

  src = fetchFromGitHub {
    owner = "FWGS";
    repo = "xash3d-fwgs";
    fetchSubmodules = true;
    rev = "0c8da36a0bf8c9aec74db7ed8f31c9c1c2eb13f8";
    hash = "sha256-6nbFi20uZWd3Y/bcjc3D9iNKMhLtxlkAwR2M5BXu6hY=";
  };

  nativeBuildInputs = [
    ensureNewerSourcesForZipFilesHook
    python3
    pkg-config
    wafHook
    makeWrapper
  ];

  buildInputs = [
    SDL2
    freetype
    opusfile
    libopus
    libogg
    libvorbis
    bzip2
  ];

  dontAddPrefix = true;

  wafConfigureFlags = [
    "-T release"
    "--sdl-use-pkgconfig"
  ] ++ lib.optionals stdenv.buildPlatform.is64bit [ "-8" ];

  CFLAGS = "-I${SDL2.dev}/include/SDL2";

  preInstall = ''
    mkdir -p $out/lib
  '';

  wafInstallFlags = [ "--destdir=${placeholder "out"}/lib" ];

  postInstall =
    ''
      mkdir -p $out/opt
      mv $out/lib/valve $out/opt

      mkdir -p $out/bin
      mv $out/lib/xash3d $out/bin/xash3d-unwrapped
      makeWrapper $out/bin/xash3d-unwrapped $out/bin/xash3d \
        --set XASH3D_RODIR $out/opt/valve \
        --run "export XASH3D_BASEDIR=\$HOME/.xash3d/" \
        --prefix ${
          if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH"
        } : "$out/lib"
    ''
    + lib.optionalString buildXashSdk ''cp -TR ${xash-sdk}/valve $out/opt/valve'';

  meta = {
    homepage = "https://github.com/FWGS/xash3d-fwgs";
    description = "Xash3D FWGS engine";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ r4v3n6101 ];
    mainProgram = "xash3d";
  };
}
