{ cabal, blazeBuilder, filepath, httpClient, httpTypes, mimeTypes
, random, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "http-client-multipart";
  version = "0.2.0.0";
  sha256 = "1bahkysh771p3mrfan1gmm6jyx62w3k57ba4rsnx7h1gwbilm878";
  buildDepends = [
    blazeBuilder filepath httpClient httpTypes mimeTypes random text
    transformers
  ];
  meta = {
    homepage = "https://github.com/snoyberg/http-client";
    description = "Generate multipart uploads for http-client";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
