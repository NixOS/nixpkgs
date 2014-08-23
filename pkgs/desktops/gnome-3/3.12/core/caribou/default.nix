{ fetchurl, stdenv, pkgconfig, gnome3, clutter, dbus, pythonPackages, libxml2
, libxklavier, libXtst, gtk2, intltool, libxslt, at_spi2_core }:


stdenv.mkDerivation rec {
  name = "caribou-0.4.13";

  src = fetchurl {
    url = "mirror://gnome/sources/caribou/0.4/${name}.tar.xz";
    sha256 = "953ba618621fda8a828d0d797fc916dbe35990dc01d7aa99d15e5e2241ee2782";
  };

  buildInputs = with gnome3;
    [ glib pkgconfig gtk clutter at_spi2_core dbus pythonPackages.python pythonPackages.pygobject3
      libxml2 libXtst gtk2 intltool libxslt ];

  propagatedBuildInputs = [ gnome3.libgee libxklavier ];

  preBuild = ''
    patchShebangs .
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };

}
