{stdenv, fetchurl, cmake, openssl}:

stdenv.mkDerivation {
  name = "libmsn-4.0beta4";
  src = fetchurl {
    url = mirror://sourceforge/libmsn/libmsn-4.0-beta4.tar.bz2;
    md5 = "b0155f01443644d7c4a60269e44d8dac";
  };
  buildInputs = [ cmake openssl ];
}
