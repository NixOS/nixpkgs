{ stdenv, fetchurl, zlib, pkgconfig, glib, libgsf, libxml2 }:

stdenv.mkDerivation rec {
  name = "libwpd-0.9.9";
  
  src = fetchurl {
    url = "mirror://sourceforge/libwpd/${name}.tar.xz";
    sha256 = "1cn2z89yzsz8k6xjl02jdfhm0pkarw3yxj9ijnz5dx7h1v5g87dr";
  };
  
  buildInputs = [ glib libgsf libxml2 zlib ];

  nativeBuildInputs = [ pkgconfig ];
}
