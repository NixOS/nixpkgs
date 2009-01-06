{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "man-pages-3.15";
  
  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.bz2";
    sha256 = "0pr29ziz2d2zl2iii16372x2bqvx1a5g8xbb6wga4nxiz4w6ixhh";
  };

  preBuild = "
    makeFlagsArray=(MANDIR=$out/share/man)
  ";

  meta = {
    description = "Linux development manual pages";
    homepage = http://kernel.org/pub/linux/docs/manpages/;
  };
}
