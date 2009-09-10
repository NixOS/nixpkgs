{ stdenv, fetchurl, lib, cmake, qt4, perl, gettext, curl, libxml2, mysql, taglib, loudmouth
, kdelibs, automoc4, phonon, strigi, soprano}:

stdenv.mkDerivation {
  name = "amarok-2.1.1";
  src = fetchurl {
    url = mirror://kde/stable/amarok/2.1.1/src/amarok-2.1.1.tar.bz2;
    sha256 = "0z0irnb86f00w8d0iapbdwygwm5vr83jhfmjd1xdldsyjrz65mi7";
  };
  includeAllQtDirs=true;
  inherit mysql loudmouth;
  builder = ./builder.sh;
  buildInputs = [ cmake qt4 perl stdenv.gcc.libc gettext curl libxml2 mysql taglib loudmouth
                  kdelibs automoc4 phonon strigi soprano ];
  meta = {
    description = "Popular music player for KDE";
    license = "GPL";
    homepage = http://amarok.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
