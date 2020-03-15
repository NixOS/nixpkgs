{ stdenv, fetchurl, pkgconfig, gettext, glib, dbus-glib, libxklavier,
  libcanberra-gtk3, libnotify, nss, polkit, dconf, gtk3, mate,
  pulseaudioSupport ? stdenv.config.pulseaudio or true, libpulseaudio,
  wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-settings-daemon";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1hc5a36wqpjv9i2lgrn1h12s8y910xab3phx5vzbzq47kj6m3gw9";
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
