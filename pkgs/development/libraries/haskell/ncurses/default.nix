{ cabal, c2hs, ncurses, text, transformers }:

cabal.mkDerivation (self: {
  pname = "ncurses";
  version = "0.2.8";
  sha256 = "0i8kbi8q0l6vka5i64aanhsid2yf8w2fj3fk33y7bv7kl791hynp";
  buildDepends = [ text transformers ];
  buildTools = [ c2hs ];
  extraLibraries = [ ncurses ];
  patchPhase = "find . -type f -exec sed -i -e 's|ncursesw/||' {} \\;";
  meta = {
    homepage = "https://john-millikin.com/software/haskell-ncurses/";
    description = "Modernised bindings to GNU ncurses";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
  };
})
