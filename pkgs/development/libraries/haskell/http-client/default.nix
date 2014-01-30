{ cabal, base64Bytestring, blazeBuilder, caseInsensitive, cookie
, dataDefault, deepseq, failure, hspec, httpTypes, monadControl
, network, publicsuffixlist, text, time, transformers, zlib
, zlibBindings
}:

cabal.mkDerivation (self: {
  pname = "http-client";
  version = "0.2.1.1";
  sha256 = "03hcwz53sjvw3nv6xbdf24a4ny229ljq3rx89plmsxpjb44qwlq2";
  buildDepends = [
    base64Bytestring blazeBuilder caseInsensitive cookie dataDefault
    deepseq failure httpTypes network publicsuffixlist text time
    transformers zlibBindings
  ];
  testDepends = [
    base64Bytestring blazeBuilder caseInsensitive dataDefault deepseq
    failure hspec httpTypes monadControl network text time transformers
    zlib zlibBindings
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/snoyberg/http-client";
    description = "An HTTP client engine, intended as a base layer for more user-friendly packages";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
