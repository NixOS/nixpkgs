{ cabal, configurator, hedis, lens, mtl, network, snap
, transformers
}:

cabal.mkDerivation (self: {
  pname = "snaplet-redis";
  version = "0.1.3.2";
  sha256 = "0554farc76ncbynzks4ryi7a2nbahsgnjvazmw5n9b79cp207bjf";
  buildDepends = [
    configurator hedis lens mtl network snap transformers
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/dzhus/snaplet-redis/";
    description = "Redis support for Snap Framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
