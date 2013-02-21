{ stdenv, fetchurl, pkgconfig, gnome3, gnome_doc_utils, intltool, which
, libxml2, libxslt }:

stdenv.mkDerivation rec {
  version = "3.5.2";
  name = "gnome-dictionary-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-dictionary/3.5/${name}.tar.xz";
    sha256 = "1cq32csxn27vir5nlixx337ym2nal9ykq3s1j7yynh2adh4m0jil";
  };

  buildInputs = [ gnome3.gtk ];
  nativeBuildInputs = [ pkgconfig intltool gnome_doc_utils which libxml2 libxslt gnome3.scrollkeeper ];
}
