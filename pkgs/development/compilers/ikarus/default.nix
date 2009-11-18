{ stdenv, fetchurl, gmp }:
        
stdenv.mkDerivation rec {
  name = "ikarus-0.0.3";
  
  src = fetchurl {
    url = "http://www.cs.indiana.edu/~aghuloum/ikarus/${name}.tar.gz";
    sha256 = "0d4vqwqfnj39l0gar2di021kcf6bfpkc6g40yapkmxm6sxpdcvjv";
  };

  buildInputs = [ gmp ];
      
  meta = {
    description = "Ikarus - a Scheme compiler, aiming at R6RS";
    homepage = http://www.cs.indiana.edu/~aghuloum/ikarus/;
    license = "GPL3";
  };
}
