{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, boost
, kdelibs, kdepimlibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdewebdev-4.3.5";
  src = fetchurl {
    url = mirror://kde/stable/4.3.5/src/kdewebdev-4.3.5.tar.bz2;
    sha256 = "0lm07pnicvv66npqzhz82q3rx236kcvqv6ismxrll4q7b7gr2xxl";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost kdelibs kdepimlibs automoc4 phonon ];
  meta = {
    description = "KDE Web development utilities";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
