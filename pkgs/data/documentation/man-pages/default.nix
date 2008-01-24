{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "man-pages-2.74";
  
  src = fetchurl {
    url = ftp://ftp.win.tue.nl/pub/linux-local/manpages/man-pages-2.74.tar.gz;
    sha256 = "1k6hf6va29gnf2c9kpwd6w555gp1vimf73ac2ij2j7dqx64hy7s7";
  };

  preBuild = "
    makeFlagsArray=(MANDIR=$out/share/man)
  ";

  meta = {
    description = "Linux development manual pages";
    homepage = ftp://ftp.win.tue.nl/pub/linux-local/manpages/;
  };
}
