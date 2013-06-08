{ cabal, alex, filepath, happy, random }:

cabal.mkDerivation (self: {
  pname = "gtk2hs-buildtools";
  version = "0.12.4";
  sha256 = "0xh5z8pix5q48d9liicl021kq9py4rj5612va6lfjkj813p5zq2z";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ filepath random ];
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Tools to build the Gtk2Hs suite of User Interface libraries";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
