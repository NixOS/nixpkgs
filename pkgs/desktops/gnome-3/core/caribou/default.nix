{ fetchurl, stdenv, pkgconfig, gnome3, clutter, dbus, python3Packages, libxml2
, libxklavier, libXtst, gtk2, intltool, libxslt, at-spi2-core, autoreconfHook
, wrapGAppsHook }:

let
  majorVersion = "0.4";
  pythonEnv = python3Packages.python.withPackages ( ps: with ps; [ pygobject3 ] );
in
stdenv.mkDerivation rec {
  name = "caribou-${majorVersion}.21";

  src = fetchurl {
    url = "mirror://gnome/sources/caribou/${majorVersion}/${name}.tar.xz";
    sha256 = "0mfychh1q3dx0b96pjz9a9y112bm9yqyim40yykzxx1hppsdjhww";
  };

  nativeBuildInputs = [ pkgconfig intltool libxslt libxml2 autoreconfHook wrapGAppsHook ];

  buildInputs = with gnome3;
    [ glib gtk clutter at-spi2-core dbus pythonEnv python3Packages.pygobject3
      libXtst gtk2 ];

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
