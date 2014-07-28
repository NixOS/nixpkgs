{ stdenv, fetchurl, openal }:

stdenv.mkDerivation rec {
  name = "freealut-1.1.0";

  src = fetchurl {
    url = "http://www.openal.org/openal_webstf/downloads/${name}.tar.gz";
    sha256 = "0kzlil6112x2429nw6mycmif8y6bxr2cwjcvp18vh6s7g63ymlb0";
  };

  buildInputs = [ openal ];

  meta = {
    homepage = "http://openal.org/";
    description = "Free implementation of OpenAL's ALUT standard";
    license = stdenv.lib.licenses.lgpl2;
  };
}
