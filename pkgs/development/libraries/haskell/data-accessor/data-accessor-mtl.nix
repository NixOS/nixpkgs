{ cabal, dataAccessor, mtl }:

cabal.mkDerivation (self: {
  pname = "data-accessor-mtl";
  version = "0.2.0.3";
  sha256 = "1aksmm4ykb96khgq5y4vd40zbn4c73hgl21xvyc295cwxsyrbvbk";
  buildDepends = [ dataAccessor mtl ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Record_access";
    description = "Use Accessor to access state in mtl State monad class";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
