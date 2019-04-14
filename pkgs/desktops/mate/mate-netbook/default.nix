{ stdenv, fetchurl, pkgconfig, intltool, gtk3, libwnck3, libfakekey, libXtst, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-netbook-${version}";
  version = "1.20.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1ils0lav6j779kgz2py6zdalcfifpnp01clspbnkhb3v1ha1ncsq";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libwnck3
    libfakekey
    libXtst
    mate.mate-panel
  ];

  meta = with stdenv.lib; {
    description = "MATE utilities for netbooks";
    longDescription = ''
      MATE utilities for netbooks are an applet and a daemon to maximize
      windows and move their titles on the panel.

      Installing these utilities is recommended for netbooks and similar
      devices with low resolution displays.
    '';
    homepage = https://mate-desktop.org;
    license = with licenses; [ gpl3 lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
