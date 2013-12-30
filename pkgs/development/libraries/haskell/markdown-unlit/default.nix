{ cabal, hspec, QuickCheck, silently, stringbuilder }:

cabal.mkDerivation (self: {
  pname = "markdown-unlit";
  version = "0.2.0.1";
  sha256 = "1bc3vcifv2xcddh8liq380c6sxarrs5pf21pfs9i4dx9rfl3hvhq";
  isLibrary = true;
  isExecutable = true;
  testDepends = [ hspec QuickCheck silently stringbuilder ];
  noHaddock = self.stdenv.lib.versionOlder self.ghc.version "7.4";
  meta = {
    description = "Literate Haskell support for Markdown";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
