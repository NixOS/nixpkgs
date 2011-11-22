{ cabal, mtl, network, time, utf8String }:

cabal.mkDerivation (self: {
  pname = "libmpd";
  version = "0.7.0";
  sha256 = "03bp3bpf1zr8srbzxjhppj7pba0h1if9lga7x5nvhlgc6p7799nw";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl network time utf8String ];
  meta = {
    homepage = "http://github.com/joachifm/libmpd-haskell";
    description = "An MPD client library";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
