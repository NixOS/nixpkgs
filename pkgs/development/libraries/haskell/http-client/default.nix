{ cabal, base64Bytestring, blazeBuilder, caseInsensitive, cookie
, dataDefaultClass, deepseq, failure, hspec, httpTypes
, monadControl, network, publicsuffixlist, text, time, transformers
, zlib, zlibBindings
}:

cabal.mkDerivation (self: {
  pname = "http-client";
  version = "0.2.2.4";
  sha256 = "19dymsi39m2m7i99xsmcl9gigqm6jhynnv0w8w230mq8vraq1mcw";
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
