{ cabal }:

cabal.mkDerivation (self: {
  pname = "stringsearch";
  version = "0.3.6.3";
  sha256 = "1f0sl1zjya8glvlscf3g5i0in0ai1knls7kg9dp82grg2k287sgz";
  meta = {
    homepage = "https://bitbucket.org/dafis/stringsearch";
    description = "Fast searching, splitting and replacing of ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
