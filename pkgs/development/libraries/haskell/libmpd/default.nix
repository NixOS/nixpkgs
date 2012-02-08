{ cabal, mtl, network, time, utf8String }:

cabal.mkDerivation (self: {
  pname = "libmpd";
  version = "0.7.1";
  sha256 = "1vahcr1vjpr1wfkifp8ih3fajz1886zhc3cj643f7s3im7wjzw5j";
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
