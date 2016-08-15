{ stdenv, fetchurl, aspell, pkgconfig, glib, hunspell, hspell }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "1.6.0";
  pname = "enchant";
  
  src = fetchurl {
    url = "http://www.abisource.com/downloads/${pname}/${version}/${name}.tar.gz";
    sha256 = "0zq9yw1xzk8k9s6x83n1f9srzcwdavzazn3haln4nhp9wxxrxb1g";
  };
  
  buildInputs = [aspell pkgconfig glib hunspell hspell];
  
  meta = {
    homepage = http://www.abisource.com/enchant;
    platforms = stdenv.lib.platforms.unix;
  };
}
