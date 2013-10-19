{ cabal, deepseq, mtl, parallel, time }:

cabal.mkDerivation (self: {
  pname = "data-pprint";
  version = "0.2.2";
  sha256 = "0cr69qv2j8fmmlir8rzlafcxk1cg3lg1z0zrwkz0lb7idm25fy36";
  buildDepends = [ deepseq mtl parallel time ];
  patches = [ (fetchurl { url = "https://github.com/divipp/ActiveHs-misc/pull/3.patch";
                          sha256 = "0wxvc7cbv4qpjl5zxy41863qpzda2ma75pmnnqx29qyh3rxp7biw";
                        })
            ];
  meta = {
    description = "Prettyprint and compare Data values";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
