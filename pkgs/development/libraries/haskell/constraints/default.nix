{ cabal, newtype }:

cabal.mkDerivation (self: {
  pname = "constraints";
  version = "0.3.4.2";
  sha256 = "14bfar4d44yl9zxgqxj4p67ag2ndprm602l4pinfjk0ywbh63fwq";
  buildDepends = [ newtype ];
  meta = {
    homepage = "http://github.com/ekmett/constraints/";
    description = "Constraint manipulation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
