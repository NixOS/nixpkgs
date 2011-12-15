{stdenv, fetchurl, cmake, zlib}:

stdenv.mkDerivation rec {
  name = "libproxy-0.4.7";
  src = fetchurl {
    url = "http://libproxy.googlecode.com/files/${name}.tar.gz";
    sha256 = "15rp97g3s2xkc842p5qfm8kx3p4awvrwrpl6w71a76qk224abq4g";
  };
  buildInputs = [cmake zlib];
}
