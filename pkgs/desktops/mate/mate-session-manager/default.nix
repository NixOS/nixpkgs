{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  xtrans,
  dbus-glib,
  systemd,
  libSM,
  libXtst,
  glib,
  gtk3,
  libepoxy,
  polkit,
  hicolor-icon-theme,
  mate-desktop,
  mate-screensaver,
  wrapGAppsHook3,
  fetchpatch,
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "mate-session-manager";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0yzkWVuh2mUpB3cgPyvIK9lzshSjoECAoe9caJkKLXs=";
  };

  patches = [
    # allow turning on debugging from environment variable
    (fetchpatch {
      url = "https://github.com/mate-desktop/mate-session-manager/commit/3ab6fbfc811d00100d7a2959f8bbb157b536690d.patch";
      sha256 = "0yjaklq0mp44clymyhy240kxlw95z3azmravh4f5pfm9dys33sg0";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    xtrans
    wrapGAppsHook3
  ];

  buildInputs = [
    dbus-glib
    systemd
    libSM
    libXtst
    gtk3
    mate-desktop
    mate-screensaver # for gsm_manager_init
    hicolor-icon-theme
    libepoxy
    polkit
  ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  postFixup = ''
    substituteInPlace $out/share/xsessions/mate.desktop \
      --replace-fail "Exec=mate-session" "Exec=$out/bin/mate-session"
  '';

  passthru.providedSessions = [ "mate" ];

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "MATE Desktop session manager";
    homepage = "https://github.com/mate-desktop/mate-session-manager";
    license = with licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
