{ stdenv, fetchurl, pkgconfig, glib, zlib, libgpgerror }:

stdenv.mkDerivation rec {
  name = "gmime-2.6.20";

  src = fetchurl {
    url = "mirror://gnome/sources/gmime/2.6/${name}.tar.xz";
    sha256 = "0rfzbgsh8ira5p76kdghygl5i3fvmmx4wbw5rp7f8ajc4vxp18g0";
  };

  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib zlib libgpgerror ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://spruce.sourceforge.net/gmime/;
    description = "A C/C++ library for manipulating MIME messages";
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
  };
}
