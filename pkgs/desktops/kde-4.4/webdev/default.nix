{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, boost
, kdelibs, kdepimlibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdewebdev-4.4.5";
  src = fetchurl {
    url = mirror://kde/stable/4.4.5/src/kdewebdev-4.4.5.tar.bz2;
    sha256 = "1yqn08xlzbcqrna76wqjmp58x28n3k47705znzqvh951ljdxds85";
  };
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost kdelibs kdepimlibs automoc4 phonon ];
  meta = {
    description = "KDE Web development utilities";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
