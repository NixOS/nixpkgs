{ cabal, arrows, binary, brainfuck, dataMemocombinators, filepath
, haskellSrc, haskellSrcExts, HTTP, IOSpec, lambdabotUtils, logict
, MonadRandom, mtl, network, numbers, oeis, parsec, random
, readline, regexCompat, show, syb, tagsoup, unlambda, utf8String
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "lambdabot";
  version = "4.2.3.2";
  sha256 = "0jy48s4z1yn0wiaxzi3pws7j9j4ih2vqr8gr8md2i35g4bwxmxp2";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    arrows binary brainfuck dataMemocombinators filepath haskellSrc
    haskellSrcExts HTTP IOSpec lambdabotUtils logict MonadRandom mtl
    network numbers oeis parsec random readline regexCompat show syb
    tagsoup unlambda utf8String vectorSpace
  ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Lambdabot";
    description = "Lambdabot is a development tool and advanced IRC bot";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
  };
})
