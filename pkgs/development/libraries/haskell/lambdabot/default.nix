{ cabal, arrows, binary, brainfuck, dataMemocombinators, filepath
, haskellSrc, haskellSrcExts, HTTP, IOSpec, lambdabotUtils, logict
, MonadRandom, mtl, network, numbers, oeis, parsec, random
, readline, regexCompat, show, syb, tagsoup, unlambda, utf8String
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "lambdabot";
  version = "4.2.3.3";
  sha256 = "1fxxmrm390pnqpf7v4kap2asaqh02sphl8r6inq4sdy1zs2rxrvk";
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
