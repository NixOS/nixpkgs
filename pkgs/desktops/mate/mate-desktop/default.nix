{ stdenv, fetchurl, pkgconfig, intltool, isocodes, gnome3, gtk3, dconf, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-desktop";
  version = "1.22.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "18w5r9p3bqpvxqqy2am7z686xf65cz5vhj247kki8s2yvvap6rlh";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    dconf
    gtk3
    isocodes
  ];

  meta = with stdenv.lib; {
    description = "Library with common API for various MATE modules";
    homepage = https://mate-desktop.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
