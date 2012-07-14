{ cabal, mtl, parsec }:

cabal.mkDerivation (self: {
  pname = "hsemail";
  version = "1.7.2";
  sha256 = "1bl017gfyvjvxs9z1fns6sknk1l55905r82i31aqbz9qyaj70gzx";
  buildDepends = [ mtl parsec ];
  meta = {
    homepage = "http://gitorious.org/hsemail";
    description = "Internet Message Parsers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
