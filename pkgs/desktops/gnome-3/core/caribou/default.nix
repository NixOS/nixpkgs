{ fetchurl, stdenv, pkgconfig, gnome3, clutter, dbus, pythonPackages, libxml2
, libxklavier, libXtst, gtk2, intltool, libxslt, at_spi2_core, autoreconfHook }:

let
  majorVersion = "0.4";
in
stdenv.mkDerivation rec {
  name = "caribou-${majorVersion}.21";

  src = fetchurl {
    url = "mirror://gnome/sources/caribou/${majorVersion}/${name}.tar.xz";
    sha256 = "0mfychh1q3dx0b96pjz9a9y112bm9yqyim40yykzxx1hppsdjhww";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];

  buildInputs = with gnome3;
    [ glib gtk clutter at_spi2_core dbus pythonPackages.python
      pythonPackages.pygobject3 libxml2 libXtst gtk2 intltool libxslt ];

  propagatedBuildInputs = [ gnome3.libgee libxklavier ];

  postPatch = ''
    patchShebangs .
    substituteInPlace libcaribou/Makefile.am --replace "--shared-library=libcaribou.so.0" "--shared-library=$out/lib/libcaribou.so.0"
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };

}
