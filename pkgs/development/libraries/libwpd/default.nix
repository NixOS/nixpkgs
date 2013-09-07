{ stdenv, fetchurl, zlib, pkgconfig, glib, libgsf, libxml2 }:

stdenv.mkDerivation rec {
  name = "libwpd-0.9.5";
  
  src = fetchurl {
    url = "mirror://sourceforge/libwpd/${name}.tar.xz";
    sha256 = "1qvmnszql8c900py83wrxnj2pyyy4107scdhvmhapp4gpmccmg7f";
  };
  
  buildInputs = [ glib libgsf libxml2 zlib ];

  nativeBuildInputs = [ pkgconfig ];
}
