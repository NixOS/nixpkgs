{stdenv, fetchurl, cmake, openssl}:

stdenv.mkDerivation rec {
  name = "libmsn-4.2.1";
  src = fetchurl {
    url = "mirror://sourceforge/libmsn/${name}.tar.bz2";
    sha256 = "338369c7455b123e84b9a7a858ac0ed2b1dc32e6529f460fdc01d28869a20fde";
  };
  buildInputs = [ cmake openssl ];
}
