{stdenv, fetchurl, curl}:

stdenv.mkDerivation {
  name = "libmicrohttpd-0.3.0";

  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/libmicrohttpd/libmicrohttpd-0.3.0.tar.gz;
    sha256 = "1m3c9akpdx2lg7klqxv5vbwjr9vwfx5k0aqn8zmf6rpdgk5c3bii";
  };

  buildInputs = [curl];
}
