{ cabal, adjunctions, comonad, contravariant, distributive, free
, mtl, pointed, semigroupoids, speculation, transformers
}:

cabal.mkDerivation (self: {
  pname = "kan-extensions";
  version = "4.0.2";
  sha256 = "05invi86i2a115jdy2nzdkc0i6g170j0xcxycw2z2qjigvjsaizi";
  buildDepends = [
    adjunctions comonad contravariant distributive free mtl pointed
    semigroupoids speculation transformers
  ];
  meta = {
    homepage = "http://github.com/ekmett/kan-extensions/";
    description = "Kan extensions, Kan lifts, various forms of the Yoneda lemma, and (co)density (co)monads";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
