{ cabal, deepseq, List, text, transformers, utf8String }:

cabal.mkDerivation (self: {
  pname = "hexpat";
  version = "0.20.5";
  sha256 = "09p8mh2b76ymgfv64zpddywdf34n7b78agri6kjnhls0xsk8260a";
  buildDepends = [ deepseq List text transformers utf8String ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Hexpat/";
    description = "XML parser/formatter based on expat";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
