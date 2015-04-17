{ fetchurl, stdenv, pkgconfig, gnome3, clutter, dbus, pythonPackages, libxml2
, libxklavier, libXtst, gtk2, intltool, libxslt, at_spi2_core }:

let
  majorVersion = "0.4";
in
stdenv.mkDerivation rec {
  name = "caribou-${majorVersion}.18.1";

  src = fetchurl {
    url = "mirror://gnome/sources/caribou/${majorVersion}/${name}.tar.xz";
    sha256 = "0l1ikx56ddgayvny3s2xv8hs3p23xsclw4zljs3cczv4b89dzymf";
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
