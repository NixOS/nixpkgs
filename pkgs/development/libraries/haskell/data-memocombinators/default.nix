{ cabal, dataInttrie }:

cabal.mkDerivation (self: {
  pname = "data-memocombinators";
  version = "0.4.4";
  sha256 = "06x79rgxi6cxrpzjzzsjk7yj7i0ajmcgns0n12lxakz9vxbqxyn2";
  buildDepends = [ dataInttrie ];
  meta = {
    homepage = "http://github.com/luqui/data-memocombinators";
    description = "Combinators for building memo tables";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
