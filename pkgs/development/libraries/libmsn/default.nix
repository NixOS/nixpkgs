{stdenv, fetchurl, cmake, openssl}:

stdenv.mkDerivation rec {
  name = "libmsn-4.1";
  src = fetchurl {
    url = "mirror://sourceforge/libmsn/${name}.tar.bz2";
    sha256 = "0p3c3gidnq4ai697dgg930hm7aap4176sbq7w7nn0mxg4rg5gwfx";
  };
  patches = [ ./libmsn-4.1-openssl-1.patch ];
  patchFlags = "-p0";
  buildInputs = [ cmake openssl ];
}
