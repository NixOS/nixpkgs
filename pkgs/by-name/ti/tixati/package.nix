{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  zlib,
  dbus,
  glib,
  gtk3,
  pango,
  gdk-pixbuf,
  dbus-glib,
  cairo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tixati";
  version = "3.42";

  src = fetchurl {
    url = "https://download.tixati.com/tixati-${finalAttrs.version}-1.x86_64.manualinstall.tar.gz";
    hash = "sha256-tuejoQQ3W9PyvABPieiYle3QYy2JKNqDvRlorSxPuHc=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    zlib
    dbus
    glib
    gtk3
    pango
    gdk-pixbuf
    dbus-glib
    cairo
  ];

  sourceRoot = "tixati-${finalAttrs.version}-1.x86_64.manualinstall";

  installPhase = ''
    runHook preInstall

    install -Dm755 tixati $out/bin/tixati
    install -Dm644 tixati.png $out/share/pixmaps/tixati.png
    install -Dm644 tixati.desktop $out/share/applications/tixati.desktop

    runHook postInstall
  '';

  meta = {
    description = "Simple and Easy to Use Bittorrent Client";
    homepage = "https://www.tixati.com/";
    downloadPage = "https://tixati.com/linux";
    changelog = "https://tixati.com/news";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ FlorisMenninga ];
    mainProgram = "tixati";
  };
})
