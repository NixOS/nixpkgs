{ stdenv, fetchurl, cmake, kdelibs, subversion, qt4, automoc4, perl, phonon,
  gettext, pkgconfig, apr, aprutil, boost, qjson }:

stdenv.mkDerivation rec {
  name = "kdevplatform-1.3.1";

  src = fetchurl {
    url = "mirror://kde/stable/kdevelop/4.3.1/src/${name}.tar.bz2";
    sha256 = "1fiqwabw5ilhw1jwvvr743dym12y3kxrs3zlqahz57yncdsglcl6";
  };

  propagatedBuildInputs = [ kdelibs qt4 phonon ];
  buildInputs = [ apr aprutil subversion boost qjson ];

  nativeBuildInputs = [ cmake automoc4 gettext pkgconfig ];

  meta = {
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.linux;
    description = "KDE libraries for IDE-like programs";
    longDescription = ''
      A free, opensource set of libraries that can be used as a foundation for
      IDE-like programs. It is programing-language independent, and is planned
      to be used by programs like: KDevelop, Quanta, Kile, KTechLab ... etc."
    '';
  };
}
