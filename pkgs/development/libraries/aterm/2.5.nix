{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "aterm-2.5";
  src = fetchurl {
    url = http://buildfarm.st.ewi.tudelft.nl/releases/meta-environment/aterm-2.5pre21238-l2q7rg38/aterm-2.5.tar.gz;
    md5 = "33ddcb1a229baf406ad1f603eb1d5995";
  };
  meta = {
    homepage = http://www.cwi.nl/htbin/sen1/twiki/bin/view/SEN1/ATerm;
    license = "LGPL";
    description = "Library for manipulation of term data structures in C";
  };
}
