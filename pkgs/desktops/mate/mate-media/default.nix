{ stdenv, fetchurl, pkgconfig, intltool, libtool, libxml2, libcanberra_gtk3, gnome3, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-media-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "0v19aipqj24367mx82ghkvgnxy1505zd35h50pi30fws36b6plll";
  };

  buildInputs = [
    libxml2
    libcanberra_gtk3
    gnome3.gtk
    mate.libmatemixer
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
    homepage = http://mate-desktop.org;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo maintainers.chpatrick ];
  };
}
