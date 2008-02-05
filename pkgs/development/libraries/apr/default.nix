{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "apr-1.2.12";
  
  src = fetchurl {
    url = http://archive.apache.org/dist/apr/apr-1.2.12.tar.bz2;
    sha256 = "0d11wa2hlhb5lnny5rcazca056b35kgccx94cd38bazw1d6b68nv";
  };

  meta = {
    homepage = http://apr.apache.org/;
    description = "The Apache Portable Runtime library";
  };
}
