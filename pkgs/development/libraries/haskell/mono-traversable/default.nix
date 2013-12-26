{ cabal, comonad, hashable, hspec, semigroupoids, semigroups, text
, transformers, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "mono-traversable";
  version = "0.2.0.0";
  sha256 = "1wg0yzim3ql73w5rsxjnglwlg8r2hqliddmdk8vwsbvg02kgwxvz";
  buildDepends = [
    comonad hashable semigroupoids semigroups text transformers
    unorderedContainers vector
  ];
  testDepends = [ hspec text ];
  meta = {
    homepage = "https://github.com/snoyberg/mono-traversable";
    description = "Type classes for mapping, folding, and traversing monomorphic containers";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
