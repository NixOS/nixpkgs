{ stdenv, fetchurl, fetchpatch, cmake, kdelibs, subversion, qt4, automoc4, phonon,
  gettext, pkgconfig, apr, aprutil, boost, qjson, grantlee }:

stdenv.mkDerivation rec {
  name = "kdevplatform-1.7.1";

  src = fetchurl {
    url = "mirror://kde/stable/kdevelop/4.7.1/src/${name}.tar.xz";
    sha256 = "dfd8953aec204f04bd949443781aa0f6d9d58c40f73027619a168bb4ffc4b1ac";
  };

  patches = [(fetchpatch {
    name = "svn-1.9.patch";
    url = "https://git.reviewboard.kde.org/r/124783/diff/raw/";
    sha256 = "1ixll5pvynb3l4znc65d82a5bj2s3c7c7is585s2wdpfzjgl5ay0";
  })];

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
  };
}
