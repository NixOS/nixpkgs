{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "jansson-2.7";

  src = fetchurl {
    url = "http://www.digip.org/jansson/releases/${name}.tar.gz";
    sha256 = "1mvq9p85khsl818i4vbszyfab0fd45mdrwrxjkzw05mk1xcyc1br";
  };

  meta = {
    homepage = "http://www.digip.org/jansson/";
    description = "C library for encoding, decoding and manipulating JSON data";
    license = stdenv.lib.licenses.mit;
  };
}
