{ stdenv, fetchurl, pkgconfig, intltool, glib, dbus_glib, libxklavier, libcanberra_gtk3, libnotify, nss, polkit, gnome3, mate, wrapGAppsHook
, pulseaudioSupport ? stdenv.config.pulseaudio or true, libpulseaudio
}:

stdenv.mkDerivation rec {
  name = "mate-settings-daemon-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "07b2jkxqv07njdrgkdck93d872p6lch1lrvi7ydnpicspg3rfid6";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    dbus_glib
    libxklavier
    libcanberra_gtk3
    libnotify
    nss
    polkit
    gnome3.gtk
    gnome3.dconf
    mate.mate-desktop
    mate.libmatekbd
    mate.libmatemixer
  ] ++ stdenv.lib.optional pulseaudioSupport libpulseaudio;

  configureFlags = stdenv.lib.optional pulseaudioSupport "--enable-pulse";

  meta = with stdenv.lib; {
    description = "MATE settings daemon";
    homepage = https://github.com/mate-desktop/mate-settings-daemon;
    license = with licenses; [ gpl2 lgpl21 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
