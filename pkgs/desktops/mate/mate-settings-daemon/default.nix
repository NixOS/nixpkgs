{ stdenv, fetchurl, pkgconfig, intltool, glib, dbus-glib, libxklavier,
  libcanberra-gtk3, libnotify, nss, polkit, gnome3, gtk3, mate,
  pulseaudioSupport ? stdenv.config.pulseaudio or true, libpulseaudio,
  wrapGAppsHook, fetchpatch, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "mate-settings-daemon";
  version = "1.22.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0idw02z0iig0pfxvlhc4dq4sr7kl1w50xscvg0jzzswnxid2l4ip";
  };

  patches = [
    # Don't use etc/dbus-1/system.d
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/mate-desktop/mate-settings-daemon/pull/296.patch";
      sha256 = "00dfn8h47zw3wr7yya82vvp19wsw51whn8jwgayn4hkjd161s9nm";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook # drop with the above patch
    intltool
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
