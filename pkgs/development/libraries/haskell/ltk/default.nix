{ cabal, Cabal, filepath, glib, gtk, mtl, parsec, transformers }:

cabal.mkDerivation (self: {
  pname = "ltk";
  version = "0.12.1.0";
  sha256 = "12x6nba5bll8fgzpxii1cf87j27jk4mn5gf1bx4ahd9v30h1a0h6";
  buildDepends = [ Cabal filepath glib gtk mtl parsec transformers ];
  meta = {
    homepage = "http://www.leksah.org";
    description = "Leksah tool kit";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.linux;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
