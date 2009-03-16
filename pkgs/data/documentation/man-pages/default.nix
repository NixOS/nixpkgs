{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "man-pages-3.18";
  
  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.bz2";
    sha256 = "7be08777fae2c873106f6d3ae09678444e635112ad9c52f9e9200439710dd8de";
  };

  preBuild = "
    makeFlagsArray=(MANDIR=$out/share/man)
  ";

  meta = {
    description = "Linux development manual pages";
    homepage = http://kernel.org/pub/linux/docs/manpages/;
  };
}
