{ cabal, alex, filepath, happy, random }:

cabal.mkDerivation (self: {
  pname = "gtk2hs-buildtools";
  version = "0.12.5.1";
  sha256 = "1zjm7y38089b57q3csgq7ydfm104ffhvsycszddkj0cgfgafshfm";
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
