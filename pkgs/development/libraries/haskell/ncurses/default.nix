{ cabal, c2hs, ncurses, text, transformers }:

cabal.mkDerivation (self: {
  pname = "ncurses";
  version = "0.2.4";
  sha256 = "0d4h85qgva1sf59g55k9xidqdpw18qj51xj7w5cqsf5pcpxgkcwh";
  buildDepends = [ text transformers ];
  buildTools = [ c2hs ];
  extraLibraries = [ ncurses ];
  preConfigure = ''
    sed -i -e "s,ncursesw/,," lib/UI/NCurses.chs
    sed -i -e "s,ncursesw/,," lib/UI/NCurses/Enums.chs
    sed -i -e "s,ncursesw/,," lib/UI/NCurses/Panel.chs
    sed -i -e "s,ncursesw/,," cbits/hsncurses-shim.c
  '';
  meta = {
    homepage = "https://john-millikin.com/software/haskell-ncurses/";
    description = "Modernised bindings to GNU ncurses";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
  };
})
