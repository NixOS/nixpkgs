{ cabal }:

cabal.mkDerivation (self: {
  pname = "TypeCompose";
  version = "0.9.9";
  sha256 = "0i89r1yaglkcc1fdhn0m4hws5rqcpmkg32ddznch7a3rz1l9gqwg";
  meta = {
    homepage = "https://github.com/conal/TypeCompose";
    description = "Type composition classes & instances";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ianwookim ];
  };
})
