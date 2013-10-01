{ cabal, aeson, syb }:

cabal.mkDerivation (self: {
  pname = "pandoc-types";
  version = "1.12.1.2";
  sha256 = "02x1s8m9zzlgj8asr4y247944pg3p8ccnh819rhs2g09qqiq4ylc";
  buildDepends = [ aeson syb ];
  meta = {
    homepage = "http://johnmacfarlane.net/pandoc";
    description = "Types for representing a structured document";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
