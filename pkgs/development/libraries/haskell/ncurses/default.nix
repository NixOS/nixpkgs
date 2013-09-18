{ cabal, c2hs, ncurses, text, transformers }:

cabal.mkDerivation (self: {
  pname = "ncurses";
  version = "0.2.6";
  sha256 = "0mcgbq67f8hfdqmvm3p59949mbxcc2mgjw889zxvxx0174kn205q";
  buildDepends = [ text transformers ];
  buildTools = [ c2hs ];
  extraLibraries = [ ncurses ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-ncurses/";
    description = "Modernised bindings to GNU ncurses";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
  };
})
