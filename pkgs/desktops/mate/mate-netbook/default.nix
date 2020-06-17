{ stdenv, fetchurl, pkgconfig, gettext, gtk3, libwnck3, libfakekey, libXtst, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-netbook";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1bmk9gq5gcqkvfppa7i1hqfph8sajc3xs189s4ha97g0ifwd98a8";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libwnck3
    libfakekey
    libXtst
    mate.mate-panel
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "MATE utilities for netbooks";
    longDescription = ''
      MATE utilities for netbooks are an applet and a daemon to maximize
      windows and move their titles on the panel.

      Installing these utilities is recommended for netbooks and similar
      devices with low resolution displays.
    '';
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl3 lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
