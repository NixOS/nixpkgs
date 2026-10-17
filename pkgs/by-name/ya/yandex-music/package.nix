{
  lib,
  stdenvNoCC,
  fetchurl,
  dpkg,
  makeWrapper,
  electron,
  libayatana-appindicator,
  asar,
  undmg,
}:
let
  version = "5.122.0";

  linuxSrc = fetchurl {
    url = "https://desktop.app.music.yandex.net/stable/Yandex_Music_amd64_${version}.deb";
    hash = "sha256-kJEzmWGJlDEm9epRixeKuvPTPbom56g6j1vhKZDcQ+M=";
  };

  darwinSrc = fetchurl {
    url = "https://desktop.app.music.yandex.net/stable/Yandex_Music_universal_${version}.dmg";
    hash = "sha256-KxToPH/SD0rXdiapoLk0PViLwzsctF/+DeuKe4YFx+w=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "yandex-music";
  inherit version;

  src = if stdenvNoCC.hostPlatform.isDarwin then darwinSrc else linuxSrc;

  nativeBuildInputs =
    if stdenvNoCC.hostPlatform.isDarwin then
      [ undmg ]
    else
      [
        dpkg
        makeWrapper
        asar
      ];

  dontConfigure = true;

  sourceRoot = ".";

  unpackPhase =
    if stdenvNoCC.hostPlatform.isDarwin then
      ''
        runHook preUnpack
        undmg $src
        runHook postUnpack
      ''
    else
      ''
        runHook preUnpack
        dpkg-deb -x $src .
        runHook postUnpack
      '';

  buildPhase = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    runHook preBuild

    asar extract opt/Яндекс\ Музыка/resources/app.asar app

    # Fix tray icon by providing assets from the host electron
    substituteInPlace app/index.js \
      --replace-warn "process.resourcesPath" "require('path').join(__dirname, '..')"

    asar pack app app.asar

    runHook postBuild
  '';

  installPhase =
    if stdenvNoCC.hostPlatform.isDarwin then
      ''
        runHook preInstall

        mkdir -p $out/Applications
        cp -r "Yandex Music.app" $out/Applications/

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        mkdir -p $out/bin $out/share/yandex-music
        install -Dm644 app.asar $out/share/yandex-music/app.asar
        cp -r opt/Яндекс\ Музыка/resources/assets $out/share/yandex-music/assets

        cp -r usr/share/applications $out/share/
        cp -r usr/share/icons $out/share/

        mv $out/share/applications/yandexmusic.desktop $out/share/applications/yandex-music.desktop

        substituteInPlace $out/share/applications/yandex-music.desktop \
          --replace-fail "/opt/Яндекс Музыка/yandexmusic" "$out/bin/yandex-music" \
          --replace-fail "Name=Яндекс Музыка" "Name=Yandex Music" \
          --replace-fail "StartupWMClass=Яндекс Музыка" "StartupWMClass=yandexmusic"

        makeWrapper ${electron}/bin/electron $out/bin/yandex-music \
          --run 'if [ -d "$HOME/.config/yandex-music" ] && [ ! -d "$HOME/.config/YandexMusic" ]; then mv "$HOME/.config/yandex-music" "$HOME/.config/YandexMusic"; fi' \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libayatana-appindicator ]}" \
          --add-flags "$out/share/yandex-music/app.asar" \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

        runHook postInstall
      '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Yandex Music Desktop App";
    homepage = "https://music.yandex.ru/";
    downloadPage = "https://music.yandex.com/download/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ shved ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = if stdenvNoCC.hostPlatform.isDarwin then "Yandex Music" else "yandex-music";
  };
}
