{ cabal, mtl, random }:

cabal.mkDerivation (self: {
  pname = "operational";
  version = "0.2.2.1";
  sha256 = "1w4bln8mj4hw5i40amah570p77wimxfpn7l2mmjk9z07zavx1rv2";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl random ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Operational";
    description = "Implementation of difficult monads made easy with operational semantics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
