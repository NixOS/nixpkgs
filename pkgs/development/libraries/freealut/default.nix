{ lib, stdenv, darwin, fetchurl, openal }:

stdenv.mkDerivation rec {
  name = "freealut-1.1.0";

  src = fetchurl {
    url = "http://www.openal.org/openal_webstf/downloads/${name}.tar.gz";
    sha256 = "0kzlil6112x2429nw6mycmif8y6bxr2cwjcvp18vh6s7g63ymlb0";
  };

  buildInputs = [ openal
  ] ++ lib.optional stdenv.isDarwin
    darwin.apple_sdk.frameworks.OpenAL
  ;

  meta = {
    homepage = "http://openal.org/";
    description = "Free implementation of OpenAL's ALUT standard";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.unix;
  };
}
