{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "man-pages-2.43";
  
  src = fetchurl {
    url = ftp://ftp.win.tue.nl/pub/linux-local/manpages/man-pages-2.43.tar.gz;
    sha256 = "01dibzkssaq0ssq61adhmri29ws9jbhbn2yxmjvb3gg8q7gjah9w";
  };

  preBuild = "
    makeFlagsArray=(MANDIR=$out/share/man)
  ";
}
