{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "hashable";
  version = "1.2.0.5";
  sha256 = "0frqr294bsx4i21xxd5pw59xpaf0nww0dh4bqn0ywblsm9c7nyqh";
  buildDepends = [ text ];
  meta = {
    homepage = "http://github.com/tibbe/hashable";
    description = "A class for types that can be converted to a hash value";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
