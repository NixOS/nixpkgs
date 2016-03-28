{ stdenv, fetchurl, cmake, kdelibs, subversion, qt4, automoc4, phonon,
  gettext, pkgconfig, apr, aprutil, boost, qjson, grantlee }:

stdenv.mkDerivation rec {
  name = "kdevplatform-1.7.3";

  src = fetchurl {
    url = "mirror://kde/stable/kdevelop/4.7.3/src/${name}.tar.bz2";
    sha256 = "195134bde11672de38838f4b341ed28c58042374ca12beedacca9d30e6ab4a2b";
  };

  patches = [ ./gettext.patch ];

  propagatedBuildInputs = [ kdelibs qt4 phonon ];
  buildInputs = [ apr aprutil subversion boost qjson grantlee ];

  nativeBuildInputs = [ cmake automoc4 gettext pkgconfig ];

  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    maintainers = [ maintainers.ambrop72 ];
    platforms = platforms.linux;
    description = "KDE libraries for IDE-like programs";
    longDescription = ''
      A free, opensource set of libraries that can be used as a foundation for
      IDE-like programs. It is programing-language independent, and is planned
      to be used by programs like: KDevelop, Quanta, Kile, KTechLab ... etc."
    '';
    homepage = https://www.kdevelop.org;
  };
}
