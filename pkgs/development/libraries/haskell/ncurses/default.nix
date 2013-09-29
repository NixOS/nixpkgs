{ cabal, c2hs, ncurses, text, transformers }:

cabal.mkDerivation (self: {
  pname = "ncurses";
  version = "0.2.7";
  sha256 = "026p6b2apgi9r65py45h3rl57xgwzyamq511a0rsb7myzagw22vz";
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
