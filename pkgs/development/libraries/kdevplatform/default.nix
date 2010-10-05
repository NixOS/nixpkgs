{ stdenv, fetchurl, cmake, kdelibs, subversion, qt4, automoc4, perl, phonon,
  gettext, pkgconfig, apr, aprutil, boost }:

stdenv.mkDerivation rec {
  name = "kdevplatform-1.0.2";

  src = fetchurl {
    url = "mirror://kde/stable/kdevelop/4.0.2/src/${name}.tar.bz2";
    sha256 = "0yn4v3jx1dks84nvi7s40a1pmnvipqx5hlbvbmdgqhhpqik5y9qg";
  };

  propagatedBuildInputs = [ kdelibs subversion qt4 phonon ];
  buildInputs = [ cmake automoc4 perl gettext pkgconfig apr aprutil boost stdenv.gcc.libc ];

  meta = with stdenv.lib; {
    maintainers = [ maintainers.urkud ];
    platforms = platforms.linux;
    description = "KDE libraries for IDE-like programs";
    longDescription = ''
      A free, opensource set of libraries that can be used as a foundation for
      IDE-like programs. It is programing-language independent, and is planned
      to be used by programs like: KDevelop, Quanta, Kile, KTechLab ... etc."
    '';
  };
}
