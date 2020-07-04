{ stdenv, fetchurl, pkgconfig, gettext, perl, itstool, isocodes, enchant, libxml2, python3, gnome3, gtksourceview3, libpeas, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "pluma";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1vmndhlhy3qkf3xs5kkv0xhbv5ar25pqz0kp17hc4qhgjzycfr0r";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
    perl
    itstool
    isocodes
    wrapGAppsHook
  ];

  buildInputs = [
    enchant
    libxml2
    python3
    gtksourceview3
    libpeas
    gnome3.adwaita-icon-theme
    mate.mate-desktop
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Powerful text editor for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
