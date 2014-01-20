{ fetchurl, stdenv, pkgconfig, gnome3, clutter, dbus, pythonPackages, libxml2
, libxklavier, libXtst, gtk2, intltool, libxslt }:


stdenv.mkDerivation rec {
  name = "caribou-0.4.12";

  src = fetchurl {
    url = "mirror://gnome/sources/caribou/0.4/${name}.tar.xz";
    sha256 = "0235sws58rg0kadxbp2nq5ha76zmhd4mr10n9qlbryf8p78qsvii";
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
