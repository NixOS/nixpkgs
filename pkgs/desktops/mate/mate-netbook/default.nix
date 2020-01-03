{ stdenv, fetchurl, pkgconfig, intltool, gtk3, libwnck3, libfakekey, libXtst, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-netbook";
  version = "1.22.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0m38v2276s2d3zs7smxyf70nyl7bcwp5665zgva28lvs8ip3gijx";
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
