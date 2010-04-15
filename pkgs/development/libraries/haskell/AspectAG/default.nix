{cabal, HList, mtl}:

cabal.mkDerivation (self : {
  pname = "AspectAG";
  version = "0.1.5";
  sha256 = "4cefc7e3404a723f0a75b29797bd9fe685c2a1b3150826b3ba09ade94565f6ff";
  propagatedBuildInputs = [HList mtl];
  meta = {
    description = "Attribute Grammars in the form of an EDSL";
    license = "LGPL";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

