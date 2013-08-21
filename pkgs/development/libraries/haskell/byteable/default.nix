{ cabal }:

cabal.mkDerivation (self: {
  pname = "byteable";
  version = "0.1.1";
  sha256 = "1qizg0kxxjqnd3cbrjhhidk5pbbciz0pb3z5kzikjjxnnnhk8fr4";
  meta = {
    homepage = "http://github.com/vincenthz/hs-byteable";
    description = "Type class for sequence of bytes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
