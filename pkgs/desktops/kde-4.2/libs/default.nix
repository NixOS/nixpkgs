{ stdenv, fetchurl, cmake, perl
, qt4, bzip2, pcre, fam, libxml2, libxslt, shared_mime_info, giflib, jasper
, openexr, aspell, avahi
, automoc4, phonon, strigi, soprano, ...
}:

stdenv.mkDerivation {
  name = "kdelibs-4.2.0";
  
  src = fetchurl {
    url = mirror://kde/stable/4.2.0/src/kdelibs-4.2.0.tar.bz2;
    md5 = "2d830a922195fefe6e073111850247ac";
  };
  
  buildInputs = [
    cmake perl qt4 stdenv.gcc.libc bzip2 pcre fam libxml2 libxslt
    shared_mime_info giflib jasper openexr aspell avahi
    automoc4 phonon strigi soprano
  ];
}
