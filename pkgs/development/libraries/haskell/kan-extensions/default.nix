{ cabal, adjunctions, comonad, contravariant, distributive, free
, mtl, pointed, semigroupoids, speculation, transformers
}:

cabal.mkDerivation (self: {
  pname = "kan-extensions";
  version = "4.0.3";
  sha256 = "05zqlxm6i66d996jcpjhnmij28a4zwc0l0nc9cyxamfwmyd9754b";
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
