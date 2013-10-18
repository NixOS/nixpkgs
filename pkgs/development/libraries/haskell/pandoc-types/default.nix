{ cabal, aeson, syb }:

cabal.mkDerivation (self: {
  pname = "pandoc-types";
  version = "1.12.2.3";
  sha256 = "05xbpsx44sys0rkf2aqs4fcv4bg02ffhicp49jgnjyw9jiynhzzj";
  buildDepends = [ aeson syb ];
  meta = {
    homepage = "http://johnmacfarlane.net/pandoc";
    description = "Types for representing a structured document";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
