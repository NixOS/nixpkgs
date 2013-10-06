{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "onig-5.9.3";
  
  src = fetchurl {
    url = http://www.geocities.jp/kosako3/oniguruma/archive/onig-5.9.3.tar.gz;
    sha256 = "0ahz0l64v2xv4jbh0w3q697xjff8jzdq2264h9jhwxl459msdfy3";
  };
  
  meta = {
    homepage = http://www.geocities.jp/kosako3/oniguruma/;
    description = "Oniguruma regular expressions library";
    license = "BSD";
  };
}
