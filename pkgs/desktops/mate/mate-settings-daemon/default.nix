{ stdenv, fetchurl, pkgconfig, intltool, glib, dbus-glib, libxklavier,
  libcanberra-gtk3, libnotify, nss, polkit, gnome3, gtk3, mate,
  pulseaudioSupport ? stdenv.config.pulseaudio or true, libpulseaudio,
  wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-settings-daemon-${version}";
  version = "1.22.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0yr5v6b9hdk20j29smbw1k4fkyg82i5vlflmgly0vi5whgc74gym";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
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
    gnome3.dconf
    mate.mate-desktop
    mate.libmatekbd
    mate.libmatemixer
  ] ++ stdenv.lib.optional pulseaudioSupport libpulseaudio;

  configureFlags = stdenv.lib.optional pulseaudioSupport "--enable-pulse";

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  meta = with stdenv.lib; {
    description = "MATE settings daemon";
    homepage = https://github.com/mate-desktop/mate-settings-daemon;
    license = with licenses; [ gpl2 lgpl21 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
