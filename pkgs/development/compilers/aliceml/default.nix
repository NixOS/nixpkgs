{stdenv, fetchurl, pkgsi686Linux, libtool, gnumake381, autoconf, automake111x, file, which, zsh, m4, pkgconfig, perl}:

stdenv.mkDerivation {
  name = "aliceml-1.4";

  aliceSrc = fetchurl {
    url = http://www.ps.uni-saarland.de/alice/download/sources/alice-1.4.tar.gz;
    sha256 = "1ay8r26g7xm9zlrlpigp6y1zmrl93hzkndb5phx7651wx8j2183r";
  };

  aliceGecodeSrc = fetchurl {
    url = http://www.ps.uni-saarland.de/alice/download/sources/alice-gecode-1.4.tar.gz;
    sha256 = "0yklpsqnm3wwzfz4vvv69dmm7q7pzpl3z7iw7wg33klng85cidl6";
  };

  aliceGtkSrc = fetchurl {
    url = http://www.ps.uni-saarland.de/alice/download/sources/alice-gtk-1.4.tar.gz;
    sha256 = "0zx4ks0pk5wgbcsflcmn0kbpa9j7pjbsc19d1s3jgp4rwb24m1an";
  };

  aliceRegexSrc = fetchurl {
    url = http://www.ps.uni-saarland.de/alice/download/sources/alice-regex-1.4.tar.gz;
    sha256 = "0myjzh3295awamghs4c88ypaa41m8sxh5jys876yq6flslw41s02";
  };

  aliceRuntimeSrc = fetchurl {
    url = http://www.ps.uni-saarland.de/alice/download/sources/alice-runtime-1.4.tar.gz;
    sha256 = "1cbca71vh16l2h0zjvhgzzs0rzq99nc8nx9a97yzw595355nq57f";
  };

  aliceSqliteSrc = fetchurl {
    url = http://www.ps.uni-saarland.de/alice/download/sources/alice-sqlite-1.4.tar.gz;
    sha256 = "0554xbx8zgqmpb7x06d7xvhlbk7bxmc237khgjs6yjcy53yf366b";
  };

  aliceXmlSrc = fetchurl {
    url = http://www.ps.uni-saarland.de/alice/download/sources/alice-xml-1.4.tar.gz;
    sha256 = "058a815a0vajjvjlsmd4ryx2bc71q6zwvyjg2c0v1gba2v3pddm0";
  };

  seamSrc = fetchurl {
    url = http://www.ps.uni-saarland.de/alice/download/sources/seam-1.4.tar.gz;
    sha256 = "1iz98jdv914whaw426d5406shlqgxqwpy3fbyb472x7d3lfra2dz";
  };

  gecodeSrc = fetchurl {
    url = http://www.gecode.org/download/gecode-1.3.1.tar.gz;
    sha256 = "0mgc6llbq166jmlq3alvagqsg3730670zvbwwkdgsqklw70v9355";
  };

  zlib = pkgsi686Linux.zlib;
  gmp = pkgsi686Linux.gmp;


  buildInputs = [
    stdenv pkgsi686Linux.gcc34 pkgsi686Linux.glibc 
    libtool gnumake381 autoconf automake111x pkgsi686Linux.zlib
    file which zsh pkgsi686Linux.gmp m4 pkgsi686Linux.gnome.gtk
    pkgsi686Linux.gnome.libgnomecanvas pkgsi686Linux.pango pkgsi686Linux.sqlite
    pkgsi686Linux.libxml2 pkgsi686Linux.lightning pkgconfig perl
  ];
 
  builder = ./builder.sh;

  meta = {
    homepage = http://www.ps.uni-saarland.de/alice/;
    description = "Alice ML is a functional programming language based on Standard ML, extended with rich support for concurrent, distributed, and constraint programming.";
    license = "BSD";
  };
}
