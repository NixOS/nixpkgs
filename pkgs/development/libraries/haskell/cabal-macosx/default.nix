{ cabal, Cabal, fgl, filepath, MissingH, parsec }:

cabal.mkDerivation (self: {
  pname = "cabal-macosx";
  version = "0.2.2";
  sha256 = "14dc7swk03q2kp5fmhwibjh0x0pzf9ah1004skgd5six0vzfc1ch";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ Cabal fgl filepath MissingH parsec ];
  meta = {
    homepage = "http://github.com/gimbo/cabal-macosx";
    description = "Cabal support for creating Mac OSX application bundles";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
