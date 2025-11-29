{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  autoPatchelfHook,
  dpkg,
  expat,
  libgbm,
  nss,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "windows95";
  version = "4.0.0";

  # Unable to build the application from sources
  src = fetchurl {
    url = "https://github.com/felixrieseberg/windows95/releases/download/v${finalAttrs.version}/windows95_4.0.0_amd64.deb";
    hash = "sha256-mbAWX2UneJIz6b0xJpBZW/qjLgtWYO7ZIyLiTO1Ib4M=";
  };

  nativeBuildInputs = [
    alsa-lib
    autoPatchelfHook
    dpkg
    expat
    libgbm
    nss
    wrapGAppsHook3
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/. $out/

    runHook postInstall
  '';

  meta = {
    description = "Windows 95 in Electron. Runs on macOS, Linux, and Windows";
    homepage = "https://github.com/felixrieseberg/windows95";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "windows95";
    platforms = lib.platforms.all;
  };
})
