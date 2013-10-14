{ cabal, charset, doctest, filepath, parsec, text, transformers
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "parsers";
  version = "0.10";
  sha256 = "090dvmdb1kmnc3k2x170y9fdifxi16hzkij1gzc51flx3bpx40i1";
  buildDepends = [
    charset parsec text transformers unorderedContainers
  ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/parsers/";
    description = "Parsing combinators";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
