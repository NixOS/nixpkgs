{stdenv, fetchurl, cmake, qt4, perl, gettext, curl, libxml2, mysql, taglib, loudmouth,
 kdelibs, automoc4, phonon, strigi, soprano}:

stdenv.mkDerivation {
  name = "amarok-2.0.2";
  src = fetchurl {
    url = mirror://kde/stable/amarok/2.0.2/src/amarok-2.0.2.tar.bz2;
    md5 = "98b78372ec6ea3432faba356c90c6dbe";
  };
  inherit mysql loudmouth;
  builder = ./builder.sh;
  buildInputs = [ cmake qt4 perl stdenv.gcc.libc gettext curl libxml2 mysql taglib loudmouth
                  kdelibs automoc4 phonon strigi soprano ];
}
