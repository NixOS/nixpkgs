{ stdenv, fetchurl, pkgconfig, gettext, itstool, gtkmm3, libxml2, libgtop, libwnck3, librsvg, polkit, systemd, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-system-monitor";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1cb36lrsn4fhsryl2kl4yq0qhp1p4r7k21w3fc2ywjga8fdxx6y5";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    gtkmm3
    libxml2
    libgtop
    libwnck3
    librsvg
    polkit
    systemd
  ];

  configureFlags = [ "--enable-systemd" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "System monitor for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = [ licenses.gpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
