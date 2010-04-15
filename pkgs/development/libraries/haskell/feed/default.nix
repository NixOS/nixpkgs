{cabal, utf8String, xml}:

cabal.mkDerivation (self : {
  pname = "feed";
  version = "0.3.7";
  sha256 = "c2d539f763cdce1b1498f1fd0707b12078337aff690f01e41db0b6e3569c08aa";
  propagatedBuildInputs = [utf8String xml];
  meta = {
    description = "Interfacing with RSS and Atom feeds";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

