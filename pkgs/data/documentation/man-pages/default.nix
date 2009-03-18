{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "man-pages-3.19";
  
  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/Archive/${name}.tar.bz2";
    sha256 = "1xzazq6wknyi2bjw39z6jswifn3gq3f2wr0mp06xgz7fzr0d266q";
  };

  preBuild = "
    makeFlagsArray=(MANDIR=$out/share/man)
  ";

  meta = {
    description = "Linux development manual pages";
    homepage = http://kernel.org/pub/linux/docs/manpages/;
  };
}
