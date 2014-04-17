{ cabal, alex, filepath, happy, hashtables, random }:

cabal.mkDerivation (self: {
  pname = "gtk2hs-buildtools";
  version = "0.12.5.2";
  sha256 = "1w4mfwkiqil9xd1xl4himb6vnl66hxb7a4vch6wh3bfad880qyiw";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ filepath hashtables random ];
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Tools to build the Gtk2Hs suite of User Interface libraries";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
