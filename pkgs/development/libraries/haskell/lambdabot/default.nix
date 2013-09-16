{ cabal, arrows, binary, brainfuck, dataMemocombinators
, dependentMap, dependentSum, dependentSumTemplate, dice
, editDistance, filepath, haskeline, haskellSrcExts, hoogle
, hslogger, hstatsd, HTTP, IOSpec, liftedBase, logict, misfortune
, monadControl, MonadRandom, mtl, mueval, network, numbers, oeis
, parsec, QuickCheck, random, randomFu, randomSource, regexTdfa
, SafeSemaphore, show, split, syb, tagsoup, time, transformers
, transformersBase, unlambda, utf8String, vectorSpace, zlib
}:

cabal.mkDerivation (self: {
  pname = "lambdabot";
  version = "4.3.0.1";
  sha256 = "19pkm4m2xk9ziai3ka4scxjavi0as8dmivz9q6vg3npmv0kyhkhb";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    arrows binary brainfuck dataMemocombinators dependentMap
    dependentSum dependentSumTemplate dice editDistance filepath
    haskeline haskellSrcExts hoogle hslogger hstatsd HTTP IOSpec
    liftedBase logict misfortune monadControl MonadRandom mtl mueval
    network numbers oeis parsec QuickCheck random randomFu randomSource
    regexTdfa SafeSemaphore show split syb tagsoup time transformers
    transformersBase unlambda utf8String vectorSpace zlib
  ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Lambdabot";
    description = "Lambdabot is a development tool and advanced IRC bot";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
