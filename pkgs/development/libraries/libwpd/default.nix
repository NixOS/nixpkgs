{ stdenv, fetchurl, pkgconfig, glib, libgsf, libxml2 }:

stdenv.mkDerivation rec {
  name = "libwpd-0.9.4";
  
  src = fetchurl {
    url = "mirror://sourceforge/libwpd/${name}.tar.xz";
    sha256 = "0qba429cqd72nwn1mzpj7llyi3kwykb2lplcfxffvq8svzxyzkxy";
  };
  
  buildInputs = [ glib libgsf libxml2 ];

  nativeBuildInputs = [ pkgconfig ];
}
