{ cabal, basicPrelude, hashable, systemFilepath, text, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.4.3";
  sha256 = "1k2iszja03s8azypl8lpkdjvvqsgzg73cl1wp4jl2fqp1psqv36q";
  buildDepends = [
    basicPrelude hashable systemFilepath text transformers
    unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "A typeclass-based Prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
