{ stdenv, fetchurl, pkgconfig, glib, zlib, libgpgerror }:

stdenv.mkDerivation rec {
  name = "gmime-2.6.15";

  src = fetchurl {
    url = "mirror://gnome/sources/gmime/2.6/${name}.tar.xz";
    sha256 = "16n9gmlwn6rphi59hrwy6dpn785s3r13h2kmrn3k61l2kfws1hml";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib zlib libgpgerror ];

  meta = {
    homepage = http://spruce.sourceforge.net/gmime/;
    description = "A C/C++ library for manipulating MIME messages";
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
  };
}
