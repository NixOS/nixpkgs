{ cabal, dataAccessor, mtl }:

cabal.mkDerivation (self: {
  pname = "data-accessor-mtl";
  version = "0.2.0.4";
  sha256 = "1i8lk0vy04giixng5addgj740cbvwlc7g62qgrmhfip0w9k93kqh";
  buildDepends = [ dataAccessor mtl ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Record_access";
    description = "Use Accessor to access state in mtl State monad class";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
