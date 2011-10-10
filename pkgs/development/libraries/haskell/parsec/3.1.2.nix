{ cabal, mtl, text }:

cabal.mkDerivation (self: {
  pname = "parsec";
  version = "3.1.2";
  sha256 = "0lhn9j2j5jlh7g0qx9f6ms63n9x1xlxg9isdvm6z0ksy3ywj9wch";
  buildDepends = [ mtl text ];
  meta = {
    homepage = "http://www.cs.uu.nl/~daan/parsec.html";
    description = "Monadic parser combinators";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
