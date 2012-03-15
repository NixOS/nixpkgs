{ cabal, deepseq, hashable }:

cabal.mkDerivation (self: {
  pname = "unordered-containers";
  version = "0.2.1.0";
  sha256 = "0zk2ip32h6faqa1pfmiw242fdarr63lds4j828ix7qhrjifwiw4p";
  buildDepends = [ deepseq hashable ];
  meta = {
    description = "Efficient hashing-based container types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
