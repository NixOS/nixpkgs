{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "man-pages-3.05";
  
  src = fetchurl {
    url = mirror://kernel/linux/docs/man-pages/man-pages-3.05.tar.bz2;
    sha256 = "08c48w41qjmv37g0fqcr1ky2y2mfnxqn55jxay079qrj5vxraink";
  };

  preBuild = "
    makeFlagsArray=(MANDIR=$out/share/man)
  ";

  meta = {
    description = "Linux development manual pages";
    homepage = ftp://ftp.win.tue.nl/pub/linux-local/manpages/;
  };
}
