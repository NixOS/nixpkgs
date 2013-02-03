{ cabal, monoidExtras, newtype, semigroups }:

cabal.mkDerivation (self: {
  pname = "dual-tree";
  version = "0.1.0.1";
  sha256 = "09bdid65frccpbh1bs01f7vprq0vfgqsb5bfa4j8yi3q773mycb2";
  buildDepends = [ monoidExtras newtype semigroups ];
  jailbreak = true;
  meta = {
    description = "Rose trees with cached and accumulating monoidal annotations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
