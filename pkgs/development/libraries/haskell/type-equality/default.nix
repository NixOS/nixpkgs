{ cabal }:

cabal.mkDerivation (self: {
  pname = "type-equality";
  version = "0.1.0.2";
  sha256 = "09m6vc5hglf3xdg0bg9lgbkgjffmbkfgcrqf5ii36l92c4dik32q";
  meta = {
    homepage = "http://github.com/hesselink/type-equality/";
    description = "Type equality, coercion/cast and other operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
