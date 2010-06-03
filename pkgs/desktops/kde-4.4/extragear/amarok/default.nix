{ stdenv, fetchurl, lib, cmake, qt4, qtscriptgenerator, perl, gettext, curl, libxml2, mysql, taglib, taglib_extras, loudmouth
, kdelibs, automoc4, phonon, strigi, soprano, qca2}:

stdenv.mkDerivation {
  name = "amarok-2.3.1";
  src = fetchurl {
    url = mirror://kde/stable/amarok/2.3.1/src/amarok-2.3.1.tar.bz2;
    sha256 = "0wjaic35bpv6dnnv2wwrbbsqbpng5cn7xfd3ykx25yjg9d6kzvrz";
  };
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
