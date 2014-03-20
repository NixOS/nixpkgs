{ cabal, base64Bytestring, blazeBuilder, caseInsensitive, cookie
, dataDefaultClass, deepseq, failure, hspec, httpTypes
, monadControl, network, publicsuffixlist, text, time, transformers
, zlib, zlibBindings
}:

cabal.mkDerivation (self: {
  pname = "http-client";
  version = "0.2.2.3";
  sha256 = "0li4mfw5lm0y0m3l3r7cbmhbch7ap9n2067jqw1l0qjm8s74nqkh";
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
