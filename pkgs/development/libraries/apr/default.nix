{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "apr-1.3.8";
  
  src = fetchurl {
    url = "mirror://apache/apr/${name}.tar.bz2";
    sha256 = "0mzsr6pv2gcp1cvppfzsd2c7zqgbw0rakjndcna49gv1dq0zgdvx";
  };

  meta = {
    homepage = http://apr.apache.org/;
    description = "The Apache Portable Runtime library";
  };
}
