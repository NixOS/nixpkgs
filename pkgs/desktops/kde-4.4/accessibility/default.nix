{stdenv, fetchurl, lib, cmake, qt4, perl, alsaLib, libXi, libXtst, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeaccessibility-4.4.0";
  src = fetchurl {
    url = mirror://kde/stable/4.4.0/src/kdeaccessibility-4.4.0.tar.bz2;
    sha256 = "0dkka6rzjd96i7mn8yia6d2mbgnl73jswm2xdnm2d2x9la6hpff3";
  };
  buildInputs = [ cmake qt4 perl alsaLib libXi libXtst kdelibs automoc4 phonon ];
  meta = {
    description = "KDE accessibility tools";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
