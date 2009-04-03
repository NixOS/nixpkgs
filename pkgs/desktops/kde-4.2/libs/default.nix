{ stdenv, fetchurl, cmake, perl
, qt4, bzip2, pcre, fam, libxml2, libxslt, shared_mime_info, giflib, jasper
, openexr, aspell, avahi
, automoc4, phonon, strigi, soprano
}:

stdenv.mkDerivation {
  name = "kdelibs-4.2.2";
  
  src = fetchurl {
    url = mirror://kde/stable/4.2.2/src/kdelibs-4.2.2.tar.bz2;
    sha1 = "7769bac38b27d8726c27eb3bb0b79f370f77457f";
  };
  
  buildInputs = [
    cmake perl qt4 stdenv.gcc.libc bzip2 pcre fam libxml2 libxslt
    shared_mime_info giflib jasper /* openexr */ aspell avahi
    automoc4 phonon strigi soprano
  ];
}
