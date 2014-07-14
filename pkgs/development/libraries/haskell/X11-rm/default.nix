{ cabal, X11 }:

cabal.mkDerivation (self: {
  pname = "X11-rm";
  version = "0.2";
  sha256 = "11jxlaad9jgjddd5v8ygy2rdrajrbm9dlp6f0mslvxa2wzn4v4r3";
  buildDepends = [ X11 ];
  preConfigure = ''mv Setup.hs Setup.lhs'';
  meta = {
    description = "A binding to the resource management functions missing from X11";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
