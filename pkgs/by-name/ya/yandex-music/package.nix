{
  lib,
  stdenvNoCC,
  fetchurl,
  dpkg,
  makeWrapper,
  asar,
  electron,
}:

stdenvNoCC.mkDerivation rec {
  pname = "yandex-music";
  version = "5.116.3";

  src = fetchurl {
    url = "https://desktop.app.music.yandex.net/stable/Yandex_Music_amd64_${version}.deb";
    hash = "sha256-GvjQiwPN0VrD+Os4b8VNMxT5i4HG4izThZmiCpja9Bg=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    asar
  ];

  dontConfigure = true;

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x "$src" .
    runHook postUnpack
  '';

  buildPhase = ''
    runHook preBuild
    asar extract "opt/Яндекс Музыка/resources/app.asar" app
    cp -r "opt/Яндекс Музыка/resources/assets" app/assets
    substituteInPlace app/index.js \
      --replace-fail "process.resourcesPath" "__dirname"
    asar pack app app.asar
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 app.asar "$out/share/yandex-music/app.asar"

    for size in 16x16 32x32 48x48 64x64 128x128 256x256 512x512; do
      install -Dm644 \
        "usr/share/icons/hicolor/$size/apps/yandexmusic.png" \
        "$out/share/icons/hicolor/$size/apps/yandexmusic.png"
    done

    install -Dm644 usr/share/applications/yandexmusic.desktop \
      "$out/share/applications/yandex-music.desktop"
    substituteInPlace "$out/share/applications/yandex-music.desktop" \
      --replace-fail 'Exec="/opt/Яндекс Музыка/yandexmusic" %U' "Exec=$out/bin/yandex-music %U"

    makeWrapper "${electron}/bin/electron" "$out/bin/yandex-music" \
      --add-flags "$out/share/yandex-music/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto}}"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Personal recommendations, selections for any occasion and new music";
    homepage = "https://music.yandex.ru/";
    downloadPage = "https://desktop.app.music.yandex.net/stable/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ shved ];
    mainProgram = "yandex-music";
  };
}
