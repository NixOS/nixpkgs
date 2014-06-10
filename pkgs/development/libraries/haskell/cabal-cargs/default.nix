{ cabal, Cabal, cabalLenses, cmdargs, either, filepath, lens
, strict, systemFileio, systemFilepath, tasty, tastyGolden, text
, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "cabal-cargs";
  version = "0.6.1";
  sha256 = "1bf903kgs16f054crwq0yyp6ijch80qn3d5ksy4j0fnyxxrdqvsa";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    Cabal cabalLenses cmdargs either lens strict systemFileio
    systemFilepath text transformers unorderedContainers
  ];
  testDepends = [ filepath tasty tastyGolden ];
  jailbreak = true;
  meta = {
    description = "A command line program for extracting compiler arguments from a cabal file";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.tomberek ];
  };
})
