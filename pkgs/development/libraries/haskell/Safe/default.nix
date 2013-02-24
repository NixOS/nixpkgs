{ cabal }:

cabal.mkDerivation (self: {
  pname = "Safe";
  version = "0.1";
  sha256 = "0ybi5r4635yjx41ig54bm426fbdzrivc5kn8fwqxmzm62ai0v623";
  meta = {
    homepage = "http://www-users.cs.york.ac.uk/~ndm/projects/libraries.php";
    description = "Library for safe (pattern match free) functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
