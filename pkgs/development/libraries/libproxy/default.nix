{stdenv, fetchurl, cmake, zlib}:

stdenv.mkDerivation rec {
  name = "libproxy-0.4.6";
  src = fetchurl {
    url = "http://libproxy.googlecode.com/files/${name}.tar.gz";
    sha256 = "9ad912e63b1efca98fb442240a2bc7302e6021c1d0b1b9363327729f29462f30";
  };
  buildInputs = [cmake zlib];
}
