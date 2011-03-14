{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "parsec";
  version = "3.1.1"; # Haskell Platform 2011.2.0.0
  sha256 = "0x34gwn9k68h69c3hw7yaah6zpdwq8hvqss27f3n4n4cp7dh81fk";
  propagatedBuildInputs = [mtl];
  meta = {
    license = "BSD";
    description = "Monadic parser combinators";
    maintainer = [self.stdenv.lib.maintainers.andres];
  };
})

