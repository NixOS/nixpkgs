
args : with args; 
rec {
  src = fetchurl {
    url = http://www.cs.indiana.edu/~aghuloum/ikarus/ikarus-0.0.3.tar.gz;
    sha256 = "0d4vqwqfnj39l0gar2di021kcf6bfpkc6g40yapkmxm6sxpdcvjv";
  };

  buildInputs = [gmp];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "ikarus-" + version;
  meta = {
    description = "Ikarus - a Scheme compiler, aiming at R6RS";
    homepage = http://www.cs.indiana.edu/~aghuloum/ikarus/;
    license = "GPL3";
  };
}
