{ stdenv, fetchurl, pkgconfig, gettext, glib, dbus-glib, libxklavier,
  libcanberra-gtk3, libnotify, nss, polkit, dconf, gtk3, mate,
  pulseaudioSupport ? stdenv.config.pulseaudio or true, libpulseaudio,
  wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-settings-daemon";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0n1ywr3ir5p536s7azdbw2mh40ylqlpx3a74mjrivbms1rpjxyab";
  };

  nativeBuildInputs = [
    gettext
    pkgconfig
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
  ] ++ stdenv.lib.optional pulseaudioSupport libpulseaudio;

  configureFlags = stdenv.lib.optional pulseaudioSupport "--enable-pulse";

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "MATE settings daemon";
    homepage = "https://github.com/mate-desktop/mate-settings-daemon";
    license = with licenses; [ gpl2 lgpl21 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
