{ fetchurl, stdenv, pkgconfig, gnome3, clutter, dbus, pythonPackages, libxml2
, libxklavier, libXtst, gtk2, intltool, libxslt, at_spi2_core }:

let
  majorVersion = "0.4";
in
stdenv.mkDerivation rec {
  name = "caribou-${majorVersion}.15";

  src = fetchurl {
    url = "mirror://gnome/sources/caribou/${majorVersion}/${name}.tar.xz";
    sha256 = "fdb7c645f4b35d2e106bb7d48fba914950ef84020fc8ad470cfab6a44e925f10";
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
	maintainers = [ maintainers.lethalman ];
  };

}
