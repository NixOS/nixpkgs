{ stdenv, fetchurl, cmake, kdelibs, subversion, qt4, automoc4, perl, phonon,
  gettext, pkgconfig, apr, aprutil, boost, qjson }:

stdenv.mkDerivation rec {
  name = "kdevplatform-1.3.0";

  src = fetchurl {
    url = "mirror://kde/stable/kdevelop/4.3.0/src/${name}.tar.bz2";
    sha256 = "0afka8999csyj8hbgmcsbn8h2by04v7n8k4mrwkl0b79crdvwbcd";
  };

  propagatedBuildInputs = [ kdelibs qt4 phonon ];
  buildInputs = [ apr aprutil subversion boost qjson ];

  buildNativeInputs = [ cmake automoc4 gettext pkgconfig ];

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
