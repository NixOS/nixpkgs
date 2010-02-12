{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, boost
, kdelibs, kdepimlibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdewebdev-4.4.0";
  src = fetchurl {
    url = mirror://kde/stable/4.4.0/src/kdewebdev-4.4.0.tar.bz2;
    sha256 = "04ikga4nwzajdq8b1hv7kkf3lg7yn1klq51q00q869yh60wdi9i2";
  };
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost kdelibs kdepimlibs automoc4 phonon ];
  meta = {
    description = "KDE Web development utilities";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
