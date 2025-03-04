{
  lib,
  config,
  fetchFromGitHub,
  stdenv,
  ensureNewerSourcesForZipFilesHook,
  python3,
  pkg-config,
  wafHook,
  xash-sdk,
  makeWrapper,

  # Options
  buildXashSdk ? true,
}:

stdenv.mkDerivation {
  pname = "xash-dedicated";
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

  dontAddPrefix = true;

  wafConfigureFlags = [
    "-T release"
    "-d"
  ] ++ lib.optionals stdenv.buildPlatform.is64bit [ "-8" ];

  preInstall = ''
    mkdir -p $out/lib
  '';

  wafInstallFlags = [ "--destdir=${placeholder "out"}/lib" ];

  postInstall =
    ''
      mkdir -p $out/bin
      mv $out/lib/xash $out/bin/xash_ded-unwrapped
      makeWrapper $out/bin/xash_ded-unwrapped $out/bin/xash_ded \
        --set XASH3D_RODIR $out/opt/valve \
        --run "export XASH3D_BASEDIR=\$HOME/.xash3d/" \
        --prefix ${
          if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH"
        } : "$out/lib"
    ''
    + lib.optionalString buildXashSdk ''
      mkdir -p $out/opt
      cp -TR ${xash-sdk}/valve $out/opt/valve
    '';

  meta = {
    homepage = "https://github.com/FWGS/xash3d-fwgs";
    description = "Xash3D FWGS dedicated server";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ r4v3n6101 ];
    mainProgram = "xash_ded";
  };
}
