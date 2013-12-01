{ cabal, dataInttrie }:

cabal.mkDerivation (self: {
  pname = "data-memocombinators";
  version = "0.5.0";
  sha256 = "1kh2xj1z68gig8y5fqfwaha0mcd41laa2di9x2hryjwdgzswxy74";
  buildDepends = [ dataInttrie ];
  meta = {
    homepage = "http://github.com/luqui/data-memocombinators";
    description = "Combinators for building memo tables";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
