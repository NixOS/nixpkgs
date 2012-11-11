{ cabal, classyPrelude, conduit, xmlConduit }:

cabal.mkDerivation (self: {
  pname = "classy-prelude-conduit";
  version = "0.4.0.1";
  sha256 = "00cp39pm7jwijd2ykbvjxvg1nyhmb2rzpp4v5srazf0vbbbzgvl2";
  buildDepends = [ classyPrelude conduit xmlConduit ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "conduit instances for classy-prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
