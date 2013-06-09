{ cabal, c2hs, parsec, random }:

cabal.mkDerivation (self: {
  pname = "hsshellscript";
  version = "3.3.1";
  sha256 = "0z3afp3r1j1in03fv2yb5sfbzgcrhdig6gay683bzgh85glwxhlp";
  buildDepends = [ parsec random ];
  buildTools = [ c2hs ];
  meta = {
    homepage = "http://www.volker-wysk.de/hsshellscript/";
    description = "Haskell for Unix shell scripting tasks";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
  };
})
