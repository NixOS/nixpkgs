{ cabal, binary, transformers }:

cabal.mkDerivation (self: {
  pname = "network-transport";
  version = "0.3.0";
  sha256 = "1i6sn5x3z1r9l7xwag68s5gsii137d5dajwr0abcbv6143ph3bvm";
  buildDepends = [ binary transformers ];
  meta = {
    homepage = "http://github.com/haskell-distributed/distributed-process";
    description = "Network abstraction layer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
