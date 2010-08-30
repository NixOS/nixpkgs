{cabal, HList, mtl}:

cabal.mkDerivation (self : {
  pname = "AspectAG";
  version = "0.2";
  sha256 = "5184ba55bc89d4afd12d1fe5f20e5d62b3b7306e771a7418db805afb70638ce7";
  propagatedBuildInputs = [HList mtl];
  meta = {
    description = "Attribute Grammars in the form of an EDSL";
    license = "LGPL";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

