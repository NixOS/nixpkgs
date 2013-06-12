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
  version = "4.3";
  sha256 = "0pjwxlq4rbmg9wj44vrillly967y35b4i995mz5167hpji05clvy";
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
