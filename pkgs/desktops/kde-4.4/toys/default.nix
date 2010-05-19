{stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, kdebase_workspace, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdetoys-4.4.3";
  src = fetchurl {
    url = mirror://kde/stable/4.4.3/src/kdetoys-4.4.3.tar.bz2;
    sha256 = "0x99qkmbbskdnznzidh52sh4hnfzvq8a3363gzs532wmabv1gnl6";
  };
  buildInputs = [ cmake qt4 perl kdelibs kdebase_workspace automoc4 phonon ];
  meta = {
    description = "KDE Toys";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
