{ cabal, enumset, eventList, explicitException, jackaudio, midi,
nonNegative, transformers }:

cabal.mkDerivation (self: {
  pname = "jack";
  version = "0.7.0.2";
  sha256 = "06mf1sw1lp81b3d4hsgc199m30drdnxzzlmsxg4p1yvydjfdk4gj";

  isExecutable = false;
  isLibrary = true;

  pkgconfigDepends = [jackaudio];

  buildDepends = [
    enumset
    eventList
    explicitException
    midi
    nonNegative
    transformers
  ];

  meta = {
    description = "Bindings for the JACK Audio Connection Kit";
    homepage    = "http://www.haskell.org/haskellwiki/JACK";
    license     = self.stdenv.lib.licenses.gpl2Plus;
    platforms   = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ertes];
  };
})
