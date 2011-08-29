{ cabal, monadControl, persistent, text }:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "0.6.1";
  sha256 = "1ggfdq1d32i5ny57cvdf8yw5pwhbw2sc31mrj1whb0ggkcwaqh9l";
  buildDepends = [ monadControl persistent text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Type-safe, non-relational, multi-backend persistence";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
