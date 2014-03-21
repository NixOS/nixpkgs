{ cabal, Cabal, filepath, glib, gtk3, mtl, parsec, transformers }:

cabal.mkDerivation (self: {
  pname = "ltk";
  version = "0.13.1.0";
  sha256 = "09ryyzjd3iazwiw714hsny2b9f4b1cfhyzc11k5xzin5kh5d804a";
  buildDepends = [
    Cabal filepath glib gtk3 mtl parsec transformers
  ];
  meta = {
    homepage = "http://www.leksah.org";
    description = "Leksah tool kit";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.linux;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
