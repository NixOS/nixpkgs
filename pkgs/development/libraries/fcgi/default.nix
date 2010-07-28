{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "fcgi-2.4.0";

  src = fetchurl {
    url = http://www.fastcgi.com/dist/fcgi.tar.gz;
    sha256 = "1f857wnl1d6jfrgfgfpz3zdaj8fch3vr13mnpcpvy8bang34bz36";
  };

  meta = { 
    description = "FastCGI  is a language independent, scalable, open extension to CG";
    homepage = http://www.fastcgi.com/;
    license = "FastCGI see LICENSE.TERMS";
  };
}
