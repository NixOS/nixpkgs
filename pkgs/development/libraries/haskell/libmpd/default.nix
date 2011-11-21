{ cabal, mtl, network, time, utf8String }:

cabal.mkDerivation (self: {
  pname = "libmpd";
  version = "0.6.0";
  sha256 = "1ln7kfiv75ykihym9ska4mvy0mrghs4swsrrkvmbh562nqmv4fvm";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl network time utf8String ];
  meta = {
    homepage = "http://github.com/joachifm/libmpd-haskell";
    description = "An MPD client library";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
  };
})
