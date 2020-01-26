{ stdenv, fetchurl, pkgconfig, intltool, libtool, libxml2, libcanberra-gtk3, gtk3, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-media";
  version = "1.22.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0m8q2rqbxzvh82yj63syd8sbfjrc8y4a8caa42zs66j9x60d1agw";
  };

  buildInputs = [
    libxml2
    libcanberra-gtk3
    gtk3
    mate.libmatemixer
    mate.mate-panel
    mate.mate-desktop
  ];

  nativeBuildInputs = [
    pkgconfig
    intltool
    libtool
    wrapGAppsHook
  ];

  meta = with stdenv.lib; {
    description = "Media tools for MATE";
    homepage = https://mate-desktop.org;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo maintainers.chpatrick ];
  };
}
