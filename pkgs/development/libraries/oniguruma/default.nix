{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "onig-5.9.4";
  
  src = fetchurl {
    url = http://www.geocities.jp/kosako3/oniguruma/archive/onig-5.9.4.tar.gz;
    sha256 = "15q62c2id918fj2i7xbdrcc79xrdafdc75lhhld98rgq3y8j30lq";
  };
  
  meta = {
    homepage = http://www.geocities.jp/kosako3/oniguruma/;
    description = "Regular expressions library";
    license = "BSD";
  };
}
