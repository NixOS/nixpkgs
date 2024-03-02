{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, glib
, dbus-glib
, libxklavier
, libcanberra-gtk3
, libnotify
, nss
, polkit
, dconf
, gtk3
, mate
, pulseaudioSupport ? stdenv.config.pulseaudio or true
, libpulseaudio
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-settings-daemon";
  version = "1.26.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "aX6mW1QpIcK3ZhRSktJo0wCcwtqDFtKnhphpBV5LGFk=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    dbus-glib
    libxklavier
    libcanberra-gtk3
    libnotify
    nss
    polkit
    gtk3
    dconf
    mate.mate-desktop
    mate.libmatekbd
    mate.libmatemixer
  ] ++ lib.optional pulseaudioSupport libpulseaudio;

  configureFlags = lib.optional pulseaudioSupport "--enable-pulse";

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "MATE settings daemon";
    homepage = "https://github.com/mate-desktop/mate-settings-daemon";
    license = with licenses; [ gpl2Plus gpl3Plus lgpl2Plus mit ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
