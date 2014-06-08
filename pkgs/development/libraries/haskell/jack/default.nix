{ cabal, enumset, eventList, explicitException, jackaudio, midi
, nonNegative, transformers
}:

cabal.mkDerivation (self: {
  pname = "jack";
  version = "0.7.0.2";
  sha256 = "06mf1sw1lp81b3d4hsgc199m30drdnxzzlmsxg4p1yvydjfdk4gj";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    enumset eventList explicitException midi nonNegative transformers
  ];
  pkgconfigDepends = [ jackaudio ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/JACK";
    description = "Bindings for the JACK Audio Connection Kit";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ertes ];
  };
})
