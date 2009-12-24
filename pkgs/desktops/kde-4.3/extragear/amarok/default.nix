{ stdenv, fetchurl, lib, cmake, qt4, qtscriptgenerator, perl, gettext, curl, libxml2, mysql, taglib, taglib_extras, loudmouth
, kdelibs, automoc4, phonon, strigi, soprano, qca2}:

stdenv.mkDerivation {
  name = "amarok-2.2.1";
  src = fetchurl {
    url = mirror://kde/stable/amarok/2.2.1/src/amarok-2.2.1.tar.bz2;
    sha256 = "020srkfhly2nz3vp2xb5cd02j27r16ygm46z05vpil2csrbv5nzk";
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
