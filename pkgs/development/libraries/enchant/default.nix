{ stdenv, fetchurl, aspell, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "enchant-1.3.0";
  
  src = fetchurl {
    url = "http://www.abisource.com/downloads/enchant/1.3.0/${name}.tar.gz";
    sha256 = "1vwqwsadnp4rf8wj7d4rglvszjzlcli0jyxh06h8inka1sm1al76";
  };
  
  buildInputs = [aspell pkgconfig glib];
  
  meta = {
    homepage = http://www.abisource.com/enchant;
  };
}
