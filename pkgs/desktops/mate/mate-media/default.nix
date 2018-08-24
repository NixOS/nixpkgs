{ stdenv, fetchurl, pkgconfig, intltool, libtool, libxml2, libcanberra-gtk3, gnome3, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-media-${version}";
  version = "1.21.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "0mgx4xjarpyvyaw0p0jnh74447y6zd93fvpi12078vyqr25dsi43";
  };

  buildInputs = [
    libxml2
    libcanberra-gtk3
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
