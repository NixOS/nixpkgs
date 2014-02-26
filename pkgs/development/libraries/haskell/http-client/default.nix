{ cabal, base64Bytestring, blazeBuilder, caseInsensitive, cookie
, dataDefaultClass, deepseq, failure, hspec, httpTypes
, monadControl, network, publicsuffixlist, text, time, transformers
, zlib, zlibBindings
}:

cabal.mkDerivation (self: {
  pname = "http-client";
  version = "0.2.2.2";
  sha256 = "1pn38vqbb8ff3gmwkzb8a2fika2rdymnlglpi3q7yn0jsvxl5xli";
  buildDepends = [
    base64Bytestring blazeBuilder caseInsensitive cookie
    dataDefaultClass deepseq failure httpTypes network publicsuffixlist
    text time transformers zlibBindings
  ];
  testDepends = [
    base64Bytestring blazeBuilder caseInsensitive deepseq failure hspec
    httpTypes monadControl network text time transformers zlib
    zlibBindings
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/snoyberg/http-client";
    description = "An HTTP client engine, intended as a base layer for more user-friendly packages";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
