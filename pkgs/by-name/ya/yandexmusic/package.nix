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
  pname = "yandexmusic";
  version = "5.67.0";
  src = fetchurl {
    url = "https://music-desktop-application.s3.yandex.net/stable/Yandex_Music_amd64_${version}.deb";
    hash = "sha256-UyFqM8rNj7Z87VtqN3L3fQY/0UlAgJev3iQ2bGlybVw=";
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
    cp -r "./opt/Яндекс Музыка" $out/libexec/yandexmusic
    ln -s $out/libexec/yandexmusic/yandexmusic $out/bin/yandexmusic
    cp -r ./usr/share $out/

    runHook postInstall
  '';

  meta = {
    description = "Personal recommendations, selections for any occasion and new music";
    homepage = "https://music.yandex.ru/";
    downloadPage = "https://music.yandex.ru/download/";
    license = lib.licenses.unfree;
    mainProgram = "yandexmusic";
    maintainers = with lib.maintainers; [
      maxmosk
    ];
    platforms = [
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
