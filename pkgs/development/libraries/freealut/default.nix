{stdenv, fetchurl, openal}:

stdenv.mkDerivation {
  name = "freealut-1.1.0";
  src = fetchurl {
    url = http://www.openal.org/openal_webstf/downloads/freealut-1.1.0.tar.gz;
    sha256 = "0kzlil6112x2429nw6mycmif8y6bxr2cwjcvp18vh6s7g63ymlb0";
  };
  buildInputs = [openal];
}
