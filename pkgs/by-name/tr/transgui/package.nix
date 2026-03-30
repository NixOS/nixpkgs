{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  makeDesktopItem,
  unzip,
  fpc,
  lazarus,
  libx11,
  glib,
  gtk2,
  gdk-pixbuf,
  pango,
  atk,
  cairo,
  openssl,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "transgui";
  version = "5.18.0-unstable-2026-02-24";

  src = fetchFromGitHub {
    owner = "transmission-remote-gui";
    repo = "transgui";
    rev = "da71b860d4920f7ab847a48bd8d804725ddbad7b";
    hash = "sha256-ZrzC0Pnf4HXC/XqOCzPfhAhfUvuchW2CgX3izfQAALo=";
  };

  nativeBuildInputs = [
    pkg-config
    unzip
  ];
  buildInputs = [
    fpc
    lazarus
    stdenv.cc
    libx11
    glib
    gtk2
    gdk-pixbuf
    pango
    atk
    cairo
    openssl
  ];

  env.NIX_LDFLAGS = ''
    -L${lib.getLib stdenv.cc.cc}/lib -lX11 -lglib-2.0 -lgtk-x11-2.0
    -lgdk-x11-2.0 -lgdk_pixbuf-2.0 -lpango-1.0 -latk-1.0 -lcairo
    -lc -lcrypto
  '';

  postPatch = ''
    substituteInPlace restranslator.pas --replace /usr/ $out/

    # Fix build with lazarus 4.0, https://github.com/transmission-remote-gui/transgui/issues/1486
    substituteInPlace main.pas --replace-warn "h <> INVALID_HANDLE_VALUE" "h >= 0"
  '';

  preBuild = ''
    FPCDIR=${fpc}/lib/fpc/${fpc.version} fpcmake -w
    lazbuild -B transgui.lpr --lazarusdir=${lazarus}/share/lazarus
  '';

  makeFlags = [
    "FPC=fpc"
    "PP=fpc"
    "INSTALL_PREFIX=$(out)"
  ];

  env.LCL_PLATFORM = "gtk2";

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "${pname} %U";
    icon = pname;
    type = "Application";
    comment = meta.description;
    desktopName = "Transmission Remote GUI";
    genericName = "BitTorrent Client";
    categories = [
      "Network"
      "FileTransfer"
      "P2P"
      "GTK"
    ];
    startupNotify = true;
    mimeTypes = [
      "application/x-bittorrent"
      "x-scheme-handler/magnet"
    ];
  };

  postInstall = ''
    mkdir -p "$out/share/applications"
    cp $desktopItem/share/applications/* $out/share/applications
    mkdir -p "$out/share/icons/hicolor/48x48/apps"
    cp transgui.png "$out/share/icons/hicolor/48x48/apps"
    mkdir -p "$out/share/transgui"
    cp -r "./lang" "$out/share/transgui"
  '';

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = {
    description = "Cross platform front-end for the Transmission BitTorrent client";
    homepage = "https://sourceforge.net/p/transgui";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ramkromberg ];
    mainProgram = "transgui";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
}
