{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "lcms-1.19";

  src = fetchurl {
    url = http://www.littlecms.com/lcms-1.19.tar.gz;
    sha256 = "1abkf8iphwyfs3z305z3qczm3z1i9idc1lz4gvfg92jnkz5k5bl0";
  };

  outputs = [ "dev" "out" "bin" "man" ];

  meta = {
    description = "Color management engine";
    homepage = http://www.littlecms.com/;
    license = stdenv.lib.licenses.mit;
  };
}
