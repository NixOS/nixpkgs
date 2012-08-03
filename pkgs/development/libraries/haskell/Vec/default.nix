{ cabal }:

cabal.mkDerivation (self: {
  pname = "Vec";
  version = "1.0.1";
  sha256 = "1v0v0ph881vynx8q8xwmn9da6qrd16g83q5i132nxys3ynl5s76m";
  meta = {
    homepage = "http://github.net/sedillard/Vec";
    description = "Fixed-length lists and low-dimensional linear algebra";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
