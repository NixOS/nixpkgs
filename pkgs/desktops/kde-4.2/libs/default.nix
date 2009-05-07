{ stdenv, fetchurl, cmake, perl
, qt4, bzip2, pcre, fam, libxml2, libxslt, shared_mime_info, giflib, jasper
, openexr, aspell, avahi
, automoc4, phonon, strigi, soprano
}:

stdenv.mkDerivation {
  name = "kdelibs-4.2.3";
  
  src = fetchurl {
    url = mirror://kde/stable/4.2.3/src/kdelibs-4.2.3.tar.bz2;
    sha1 = "c4cde3ea347d89d79ffdead203c85b1c2d1f8757";
  };
  
  buildInputs = [
    cmake perl qt4 stdenv.gcc.libc bzip2 pcre fam libxml2 libxslt
    shared_mime_info giflib jasper /* openexr */ aspell avahi
    automoc4 phonon strigi soprano
  ];
}
