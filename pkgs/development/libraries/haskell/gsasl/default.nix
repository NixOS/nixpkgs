{ cabal, gsasl, transformers }:

cabal.mkDerivation (self: {
  pname = "gsasl";
  version = "0.3.5";
  sha256 = "1797rs6syrgs82akbj7nkmj0nni4w83fhwrl1zy2l3jqkcacvbm3";
  buildDepends = [ transformers ];
  pkgconfigDepends = [ gsasl ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-gsasl/";
    description = "Bindings for GNU libgsasl";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
  };
})
