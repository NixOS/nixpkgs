{ cabal, classyPrelude, conduit, hspec, monadControl, QuickCheck
, resourcet, systemFileio, transformers, void
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude-conduit";
  version = "0.6.0";
  sha256 = "122clkwrz1n009b5gxq96sbby7i8kb4dgvc90ydamd86bx3pvc84";
  buildDepends = [
    classyPrelude conduit monadControl resourcet systemFileio
    transformers void
  ];
  testDepends = [ conduit hspec QuickCheck transformers ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "conduit instances for classy-prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
