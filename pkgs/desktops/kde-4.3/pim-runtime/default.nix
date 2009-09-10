{stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, kdelibs_experimental, kdepimlibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdepim-runtime-4.3.1";
  src = fetchurl {
    url = mirror://kde/stable/4.3.1/src/kdepim-runtime-4.3.1.tar.bz2;
    sha1 = "c39b0fc1d3721fb8c6074ba6a174ad8716c6c604";
  };
  buildInputs = [ cmake qt4 perl kdelibs kdelibs_experimental kdepimlibs automoc4 phonon ];
  meta = {
    description = "KDE PIM runtime";
    homepage = http://www.kde.org;
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
