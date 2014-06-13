{ cabal, binary, cereal, doctest, filepath, mtl, text, time
, transformers, transformersCompat, void
}:

cabal.mkDerivation (self: {
  pname = "bytes";
  version = "0.14.0.2";
  sha256 = "1bdradf5lq1kgiri64zd8cvcw2fxwbwv0apznl8vxyqlx406v3rn";
  buildDepends = [
    binary cereal mtl text time transformers transformersCompat void
  ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/analytics/bytes";
    description = "Sharing code for serialization between binary and cereal";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
