{ cabal, filepath, mtl, network, time, utf8String }:

cabal.mkDerivation (self: {
  pname = "libmpd";
  version = "0.7.2";
  sha256 = "109bm5fgwmydh3bi93wxr6ac3gkp7pcvp4a8z226c1wlgc995zap";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath mtl network time utf8String ];
  meta = {
    homepage = "http://github.com/joachifm/libmpd-haskell";
    description = "An MPD client library";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
