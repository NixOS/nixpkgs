{ cabal, configurator, hedis, lens, mtl, network, snap
, transformers
}:

cabal.mkDerivation (self: {
  pname = "snaplet-redis";
  version = "0.1.3.1";
  sha256 = "1aprz9rxs01a86vfr8s7mjydafdfljg89grl7i43vmsw927izc6k";
  buildDepends = [
    configurator hedis lens mtl network snap transformers
  ];
  meta = {
    homepage = "https://github.com/dzhus/snaplet-redis/";
    description = "Redis support for Snap Framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
  jailbreak = true;
})
