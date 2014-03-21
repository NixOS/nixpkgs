{ cabal, blazeBuilder, monoTraversable, semigroups, systemFilepath
, text, transformers, vector
}:

cabal.mkDerivation (self: {
  pname = "chunked-data";
  version = "0.1.0.1";
  sha256 = "0kdq79mxi9nhy3dqw283f5ffx4rxwfrdq9cfw46ql5wmqrg2qw7r";
  buildDepends = [
    blazeBuilder monoTraversable semigroups systemFilepath text
    transformers vector
  ];
  meta = {
    homepage = "https://github.com/fpco/chunked-data";
    description = "Typeclasses for dealing with various chunked data representations";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
