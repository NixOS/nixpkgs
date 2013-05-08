{ cabal, tagged }:

cabal.mkDerivation (self: {
  pname = "reflection";
  version = "1.3.1";
  sha256 = "0d81zvyg846jp0xkdkj4220w6hbrnzf46zcxs5qb5frm41rwcsj8";
  buildDepends = [ tagged ];
  meta = {
    homepage = "http://github.com/ekmett/reflection";
    description = "Reifies arbitrary terms into types that can be reflected back into terms";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
