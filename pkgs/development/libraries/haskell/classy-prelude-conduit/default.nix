{ cabal, classyPrelude, conduit, xmlConduit }:

cabal.mkDerivation (self: {
  pname = "classy-prelude-conduit";
  version = "0.4.1";
  sha256 = "0llir0xnnyhgxifay019x64jw7mnn9p1sqs1xwm14gjcqr2nqqg8";
  buildDepends = [ classyPrelude conduit xmlConduit ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "conduit instances for classy-prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
