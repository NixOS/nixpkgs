{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name = "ikarus-0.0.3";

  src = fetchurl {
    url = "http://ikarus-scheme.org/${name}.tar.gz";
    sha256 = "0d4vqwqfnj39l0gar2di021kcf6bfpkc6g40yapkmxm6sxpdcvjv";
  };

  buildInputs = [ gmp ];

  meta = {
    description = "Ikarus - a Scheme compiler, aiming at R6RS";
    homepage = http://ikarus-scheme.org/;
    license = "GPLv3";
  };
}
