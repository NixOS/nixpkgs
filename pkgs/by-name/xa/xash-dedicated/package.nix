{
  lib,
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
  version = "0-unstable-2025-11-09";

  src = fetchFromGitHub {
    owner = "FWGS";
    repo = "xash3d-fwgs";
    fetchSubmodules = true;
    rev = "d366e04682812f41d838e7c66b7f0edd51ae14a0";
    hash = "sha256-EdPMitGC2B8MbMQznJiDbx2InzHvQ8rPaVEuq4SjSWM=";
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
  ]
  ++ lib.optionals stdenv.buildPlatform.is64bit [ "-8" ];

  preInstall = ''
    mkdir -p $out/lib
  '';

  wafInstallFlags = [ "--destdir=${placeholder "out"}/lib" ];

  postInstall = ''
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
