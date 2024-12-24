{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  makeBinaryWrapper,
  alsa-lib,
  e2fsprogs,
  fontconfig,
  gmp,
  harfbuzz,
  hicolor-icon-theme,
  libdrm,
  libGL,
  libgpg-error,
  libthai,
  nss,
  p11-kit,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "webull-desktop";
  version = "8.2.0";

  src = fetchurl {
    url = "https://u1sweb.webullfintech.com/us/Webull%20Desktop_8.2.0_800200_global_x64signed.deb";
    hash = "sha256-/KVY6I9gYWWZSJhsTW5GECCeOsx+6XAVIRpghlJUK4k=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeBinaryWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    alsa-lib
    e2fsprogs
    fontconfig
    gmp
    harfbuzz
    libdrm
    libGL
    libgpg-error
    libthai
    nss
    p11-kit
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r * $out

    mkdir $out/bin
    ln -s $out/usr/local/WebullDesktop/WebullDesktop $out/bin/webull-desktop
    substituteInPlace $out/usr/share/applications/WebullDesktop.desktop \
      --replace-fail Categories=Utiltity Categories=Finance

    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop
    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/platforms
    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/bearer
    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/iconengines
    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/imageformats
    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/platforminputcontexts
    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/platforms
    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/position
    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/printsupport
    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/sqldrivers
    addAutoPatchelfSearchPath $out/usr/local/WebullDesktop/plugins/xcbglintegrations

    wrapProgram $out/usr/local/WebullDesktop/WebullDesktop --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs}:$out:$out/usr/local/WebullDesktop/platforms:$out/usr/local/WebullDesktop/platformsbearer:$out/usr/local/WebullDesktop/platformsiconengines:$out/usr/local/WebullDesktop/platformsimageformats:$out/usr/local/WebullDesktop/platformsplatforminputcontexts:$out/usr/local/WebullDesktop/platformsplatforms:$out/usr/local/WebullDesktop/platformsposition:$out/usr/local/WebullDesktop/platformsprintsupport:$out/usr/local/WebullDesktop/platformssqldrivers:$out/usr/local/WebullDesktop/platformsxcbglintegrations

    runHook postInstall
  '';

  meta = with lib; {
    description = "Webull desktop trading application";
    homepage = "https://www.webull.com/trading-platforms/desktop-app";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ fauxmight ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "webull-desktop";
  };
})
