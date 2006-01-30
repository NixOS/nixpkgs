{stdenv, fetchurl, zlib}:

assert zlib != null;

stdenv.mkDerivation {
  name = "libpng-1.2.8";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libpng-1.2.8-config.tar.gz;
    md5 = "e5a39003eed16103cbbd3b6a8bc6b1f9";
  };
  propagatedBuildInputs = [zlib];
  inherit zlib;
}
