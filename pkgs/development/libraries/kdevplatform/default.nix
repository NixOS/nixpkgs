{ stdenv, fetchurl, cmake, kdelibs, subversion, qt4, automoc4, perl, phonon,
  gettext, pkgconfig, apr, aprutil, boost, qjson }:

stdenv.mkDerivation rec {
  name = "kdevplatform-1.2.3";

  src = fetchurl {
    url = "mirror://kde/stable/kdevelop/4.2.3/src/${name}.tar.bz2";
    sha256 = "1h55lh7kkb8d9qgf4yyzmdwn7vq8l49lzlq92jccz7p79lxb2s08";
  };

  propagatedBuildInputs = [ kdelibs subversion qt4 phonon ];
  buildInputs =
    [ cmake automoc4 perl gettext pkgconfig apr aprutil boost
      stdenv.gcc.libc qjson
    ];

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
