{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "man-pages-posix-2003a";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/man-pages-posix/man-pages-posix-2003-a.tar.bz2";
    sha256 = "1sj97lbj27w935f9ia91ih1mwlz4j3qcr3d3nkvcxm6cpfvv2mg3";
  };

  preBuild =
    ''
      makeFlagsArray=(MANDIR=$out/share/man)
    '';

  meta = {
    description = "POSIX man-pages (0p, 1p, 3p)";
    homepage = http://kernel.org/pub/linux/docs/manpages/;
  };
}
