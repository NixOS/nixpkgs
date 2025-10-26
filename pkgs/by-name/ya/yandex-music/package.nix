{
  lib,
  stdenvNoCC,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  libuuid,
  libsecret,
  gtk3,
  libnotify,
  nss,
  xorg,
  at-spi2-core,
  alsa-lib,
  libgbm,
}:
stdenvNoCC.mkDerivation rec {
  pname = "yandex-music";
  version = "5.74.1";
  src = fetchurl {
    url = "https://music-desktop-application.s3.yandex.net/stable/Yandex_Music_amd64_${version}.deb";
    hash = "sha256-EBcVjmKr+lp4umDXrk67FOueA4MXCaGWpDzAVakN+zI=";
  };

  buildInputs = [
    libuuid
    libsecret
    gtk3
    libnotify
    nss
    xorg.libXtst
    at-spi2-core
    alsa-lib
    libgbm
  ];
  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec $out/bin
    cp -r "./opt/Яндекс Музыка" $out/libexec/yandex-music
    ln -s $out/libexec/yandex-music/yandexmusic $out/bin/yandex-music
    cp -r ./usr/share $out/

    runHook postInstall
  '';

  meta = {
    description = "Personal recommendations, selections for any occasion and new music";
    homepage = "https://music.yandex.ru/";
    downloadPage = "https://music.yandex.ru/download/";
    license = lib.licenses.unfree;
    mainProgram = "yandex-music";
    maintainers = with lib.maintainers; [
      shved
    ];
    platforms = [
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
