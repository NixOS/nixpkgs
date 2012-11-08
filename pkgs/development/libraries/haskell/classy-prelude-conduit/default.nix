{ cabal, classyPrelude, conduit, xmlConduit }:

cabal.mkDerivation (self: {
  pname = "classy-prelude-conduit";
  version = "0.4.0";
  sha256 = "1abx3nrnd39l0319qwj11gsfq3ji9babrs6h60s8fp2cfkvqzalz";
  buildDepends = [ classyPrelude conduit xmlConduit ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "conduit instances for classy-prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
