{ cabal, Cabal, mtl, network, parsec, xhtml }:

cabal.mkDerivation (self: {
  pname = "cgi";
  version = "3001.1.7.1";
  sha256 = "7d1d710871fffbbec2a33d7288b2959ddbcfd794d47f0122127576c02550b339";
  buildDepends = [ Cabal mtl network parsec xhtml ];
  meta = {
    description = "A library for writing CGI programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
