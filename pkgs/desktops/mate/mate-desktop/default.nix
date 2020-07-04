{ stdenv, fetchurl, pkgconfig, gettext, isocodes, gnome3, gtk3, dconf, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-desktop";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0l4bbj6nz315s5ndq5sw1jcgi3s1whk59bj12c4mbpsvmlb33adg";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
    wrapGAppsHook
  ];

  buildInputs = [
    dconf
    gtk3
    isocodes
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Library with common API for various MATE modules";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
