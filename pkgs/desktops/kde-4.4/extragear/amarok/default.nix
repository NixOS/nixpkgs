{ stdenv, fetchurl, lib, cmake, qt4, perl, gettext, curl, libxml2, mysql, taglib, taglib_extras, loudmouth
, kdelibs, automoc4, phonon, strigi, soprano, qca2}:

stdenv.mkDerivation {
  name = "amarok-2.3.0";
  src = fetchurl {
    url = mirror://kde/stable/amarok/2.3.0/src/amarok-2.3.0.tar.bz2;
    sha256 = "1a2c6qy2ik9l7r1lxm82h49acvzxsxxlnlgzwhlrhi27p3sk0xpw";
  };
  inherit mysql loudmouth;
  QT_PLUGIN_PATH="${qtscriptgenerator}/lib/qt4/plugins";
  builder = ./builder.sh;
  buildInputs = [ cmake qt4  perl stdenv.gcc.libc gettext curl libxml2 mysql taglib taglib_extras loudmouth
                  kdelibs automoc4 phonon strigi soprano qca2];
  meta = {
    description = "Popular music player for KDE";
    license = "GPL";
    homepage = http://amarok.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
