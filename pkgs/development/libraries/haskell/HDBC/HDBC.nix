{ cabal, convertible, mtl, text, time, utf8String }:

cabal.mkDerivation (self: {
  pname = "HDBC";
  version = "2.3.1.0";
  sha256 = "1y3qcc0ids9k3af4qkhabwg82q03a21wl4vdqhj1h0zmf08b3m6k";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ convertible mtl text time utf8String ];
  meta = {
    homepage = "https://github.com/jgoerzen/hdbc/wiki";
    description = "Haskell Database Connectivity";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
