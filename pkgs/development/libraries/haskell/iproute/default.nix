{ cabal, appar, byteorder, doctest, hspec, network, QuickCheck
, safe
}:

cabal.mkDerivation (self: {
  pname = "iproute";
  version = "1.2.12";
  sha256 = "19pr6my4nw7qq9lsp6xvz55lm9svwzqka5qcqy79sfdkxg459rg5";
  buildDepends = [ appar byteorder network ];
  testDepends = [
    appar byteorder doctest hspec network QuickCheck safe
  ];
  meta = {
    homepage = "http://www.mew.org/~kazu/proj/iproute/";
    description = "IP Routing Table";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
