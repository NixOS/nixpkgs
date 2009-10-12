{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "apr-1.3.9";
  
  src = fetchurl {
    url = "mirror://apache/apr/${name}.tar.bz2";
    sha256 = "1qicxnk62d9mjza8vch2wxy4xlq8sa76chwi5cp6bs4cyj9s61ap";
  };

  meta = {
    homepage = http://apr.apache.org/;
    description = "The Apache Portable Runtime library";
  };
}
