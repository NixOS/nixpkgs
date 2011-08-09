{cabal} :

cabal.mkDerivation (self : {
  pname = "bytestring-nums";
  version = "0.3.3";
  sha256 = "09gdbyj5qw98j57cs9phzsbmvdm7y6j07wg908i34jklwm24nxfd";
  meta = {
    homepage = "http://github.com/solidsnack/bytestring-nums";
    description = "Parse numeric literals from ByteStrings.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
