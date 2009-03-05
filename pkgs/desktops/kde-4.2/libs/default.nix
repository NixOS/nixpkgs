{ stdenv, fetchurl, cmake, perl
, qt4, bzip2, pcre, fam, libxml2, libxslt, shared_mime_info, giflib, jasper
, openexr, aspell, avahi
, automoc4, phonon, strigi, soprano
}:

stdenv.mkDerivation {
  name = "kdelibs-4.2.1";
  
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/kdelibs-4.2.1.tar.bz2;
    sha1 = "d2214b9864b64e4a8382a9f593d082c801c58571";
  };
  
  buildInputs = [
    cmake perl qt4 stdenv.gcc.libc bzip2 pcre fam libxml2 libxslt
    shared_mime_info giflib jasper /* openexr */ aspell avahi
    automoc4 phonon strigi soprano
  ];
}
