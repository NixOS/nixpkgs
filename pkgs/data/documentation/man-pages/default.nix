{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "man-pages-3.11";
  
  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.bz2";
    sha256 = "1pl3jdp7vh6vl2drqdal3ggdc22icdgfkfbswh21k8jlcxf00dn8";
  };

  preBuild = "
    makeFlagsArray=(MANDIR=$out/share/man)
  ";

  meta = {
    description = "Linux development manual pages";
    homepage = http://kernel.org/pub/linux/docs/manpages/;
  };
}
