{ cabal, newtype }:

cabal.mkDerivation (self: {
  pname = "constraints";
  version = "0.3.5";
  sha256 = "01xrk0xqkfwzzr5jwkadkyjgrdcpslwiqfqdb7mci688xp2isi3i";
  buildDepends = [ newtype ];
  meta = {
    homepage = "http://github.com/ekmett/constraints/";
    description = "Constraint manipulation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
