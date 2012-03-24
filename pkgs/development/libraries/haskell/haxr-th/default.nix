{ cabal, haxr }:

cabal.mkDerivation (self: {
  pname = "haxr-th";
  version = "3000.5";
  sha256 = "1h1g4r7c5k3rja49ip4m21f2sscn06xjxharnlyazvvs6mzfysif";
  buildDepends = [ haxr ];
  meta = {
    homepage = "http://www.haskell.org/haxr/";
    description = "Automatic deriving of XML-RPC structs for Haskell records";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
