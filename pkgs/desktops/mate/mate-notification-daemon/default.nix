{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf-archive,
  autoreconfHook,
  pkg-config,
  gettext,
  glib,
  libcanberra-gtk3,
  libnotify,
  libwnck,
  gtk-layer-shell,
  gtk3,
  libxml2,
  mate-common,
  mate-desktop,
  mate-panel,
  wrapGAppsHook3,
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "mate-notification-daemon";
  version = "1.28.5";
  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "mate-notification-daemon";
    tag = "v${version}";
    hash = "sha256-6N6lD63JL9xAtALn9URjYiCEhMZBC9TfIsrdalyY3YY=";
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
    gettext
    libxml2 # for xmllint
    mate-common # mate-common.m4 macros
    wrapGAppsHook3
  ];

  buildInputs = [
    libcanberra-gtk3
    libnotify
    libwnck
    gtk-layer-shell
    gtk3
    mate-desktop
    mate-panel
  ];

  configureFlags = [ "--enable-in-process" ];

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Notification daemon for MATE Desktop";
    mainProgram = "mate-notification-properties";
    homepage = "https://github.com/mate-desktop/mate-notification-daemon";
    license = with licenses; [
      gpl2Plus
      gpl3Plus
    ];
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
