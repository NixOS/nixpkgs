{ cabal, comonad, dataDefaultClass, semigroupoids, semigroups, stm
, tagged, transformers
}:

cabal.mkDerivation (self: {
  pname = "pointed";
  version = "4.1";
  sha256 = "1l40nl1sx16hbqz1kv70g6jp2igvvj93p5db8b6bsgjxx9ibck6g";
  buildDepends = [
    comonad dataDefaultClass semigroupoids semigroups stm tagged
    transformers
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/ekmett/pointed/";
    description = "Pointed and copointed data";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
