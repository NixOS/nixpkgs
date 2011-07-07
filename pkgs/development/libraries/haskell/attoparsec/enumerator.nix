{cabal, attoparsec, enumerator}:

cabal.mkDerivation (self : {
  pname = "attoparsec-enumerator";
  version = "0.2.0.4";
  sha256 = "14v53vppcf4k3m4kid10pg5r3zsn894f36w1y2pzlc72w81fv3gd";
  propagatedBuildInputs = [attoparsec enumerator];
  meta = {
    description = "Converts an Attoparsec parser into an iteratee";
    license = "BSD3";
  };
})

