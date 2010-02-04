{ stdenv, fetchurl, lib, cmake, qt4, qtscriptgenerator, perl, gettext, curl, libxml2, mysql, taglib, taglib_extras, loudmouth
, kdelibs, automoc4, phonon, strigi, soprano, qca2}:

stdenv.mkDerivation {
  name = "amarok-2.2.2";
  src = fetchurl {
    url = mirror://kde/stable/amarok/2.2.2/src/amarok-2.2.2.tar.bz2;
    sha256 = "0kg67b9wz2wi1gyn229vzbib4s0wpgqrjyfqy0032yl9fa2k13bn";
  };
  includeAllQtDirs=true;
  inherit mysql loudmouth;
  QT_PLUGIN_PATH="${qtscriptgenerator}/lib/qt4/plugins";
  builder = ./builder.sh;
  buildInputs = [ cmake qt4 qtscriptgenerator perl stdenv.gcc.libc gettext curl libxml2 mysql taglib taglib_extras loudmouth
                  kdelibs automoc4 phonon strigi soprano qca2];
  meta = {
    description = "Popular music player for KDE";
    license = "GPL";
    homepage = http://amarok.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
