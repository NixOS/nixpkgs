{ stdenv, fetchurl, pkgconfig, gnome3, intltool }:

stdenv.mkDerivation rec {
  name = "gnome-backgrounds-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-backgrounds/${gnome3.version}/${name}.tar.xz";
    sha256 = "deeea0499f34b118d27d94e3ac8d23e3b210bd602b2c1aa0e0242a75ae78c126";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
	maintainers = [ maintainers.lethalman ];
  };
}
