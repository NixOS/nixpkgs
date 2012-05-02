{ cabal, filepath, mtl, network, text, time, utf8String }:

cabal.mkDerivation (self: {
  pname = "libmpd";
  version = "0.8.0";
  sha256 = "0sn9yqiqr011glb7q0f3xj24wkkvnib0khzf833npcas4420d0ya";
  buildDepends = [ filepath mtl network text time utf8String ];
  meta = {
    homepage = "http://github.com/joachifm/libmpd-haskell";
    description = "An MPD client library";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
