{ cabal, blazeBuilder, enumerator, httpTypes, network, text
, transformers
}:

cabal.mkDerivation (self: {
  pname = "wai";
  version = "0.4.1";
  sha256 = "089i9qj7vban1qdrdpx836c31yakg3l3lx7y36h56livy6n37k72";
  buildDepends = [
    blazeBuilder enumerator httpTypes network text transformers
  ];
  meta = {
    homepage = "http://github.com/snoyberg/wai";
    description = "Web Application Interface";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
