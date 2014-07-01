{ cabal, binary, cereal, comonad, deepseq, doctest, filepath
, hashable, lens, profunctors, safecopy, transformers
, transformersCompat, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "tables";
  version = "0.4.1";
  sha256 = "131c97lgni0b9pmkdfd5y0lwrb9yh9qyahknhrim8dzpkkfynk49";
  buildDepends = [
    binary cereal comonad deepseq hashable lens profunctors safecopy
    transformers transformersCompat unorderedContainers
  ];
  testDepends = [
    doctest filepath lens transformers unorderedContainers
  ];
  meta = {
    homepage = "http://github.com/ekmett/tables/";
    description = "In-memory storage with multiple keys using lenses and traversals";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
