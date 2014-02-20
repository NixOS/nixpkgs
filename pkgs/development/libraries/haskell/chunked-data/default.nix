{ cabal, blazeBuilder, monoTraversable, semigroups, systemFilepath
, text, transformers, vector
}:

cabal.mkDerivation (self: {
  pname = "chunked-data";
  version = "0.1.0.0";
  sha256 = "1wdgvhf170rv557dwsiqy6nhys965xhs6w24ays273fv8hn3yk9l";
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
