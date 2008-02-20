args: with args;
stdenv.mkDerivation rec {
  name = "enchant-" + version;
  src = fetchurl {
    url = "http://www.abisource.com/downloads/enchant/${version}/${name}.tar.gz";
    sha256 = "1vwqwsadnp4rf8wj7d4rglvszjzlcli0jyxh06h8inka1sm1al76";
  };
  buildInputs = [aspell pkgconfig glib];
  configureFlags = "--enable-shared --disable-static";

  meta = {
    homepage = http://www.abisource.com/enchant;
  };
}
