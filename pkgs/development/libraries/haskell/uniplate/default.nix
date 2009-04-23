{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "uniplate";
  version = "1.2.0.3";
  sha256 = "77cf07c96ae62799d790284c0c84beca9ee17c9c2416d4de6641f3fddd644b58";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Uniform type generic traversals";
  };
})  

