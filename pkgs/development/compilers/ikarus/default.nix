{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  version = "0.0.3";
  name = "ikarus-${version}";

  src = fetchurl {
    url = "http://launchpad.net/ikarus/0.0/${version}/+download/${name}.tar.gz";
    sha256 = "0d4vqwqfnj39l0gar2di021kcf6bfpkc6g40yapkmxm6sxpdcvjv";
  };

  buildInputs = [ gmp ];

  meta = {
    description = "Ikarus - a Scheme compiler, aiming at R6RS";
    homepage = http://ikarus-scheme.org/;
    license = stdenv.lib.licenses.gpl3;
  };
}
