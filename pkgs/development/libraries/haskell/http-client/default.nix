{ cabal, async, base64Bytestring, blazeBuilder, caseInsensitive
, cookie, dataDefaultClass, deepseq, exceptions, filepath, hspec
, httpTypes, mimeTypes, monadControl, network, publicsuffixlist
, random, streamingCommons, text, time, transformers, zlib
}:

cabal.mkDerivation (self: {
  pname = "http-client";
  version = "0.3.2.2";
  sha256 = "1znfcn549zxz4wdlv9rvyqz0x52ygx9jba9r1fzxk08mbi8xz6ff";
  buildDepends = [
    base64Bytestring blazeBuilder caseInsensitive cookie
    dataDefaultClass deepseq exceptions filepath httpTypes mimeTypes
    network publicsuffixlist random streamingCommons text time
    transformers
  ];
  testDepends = [
    async base64Bytestring blazeBuilder caseInsensitive deepseq hspec
    httpTypes monadControl network streamingCommons text time
    transformers zlib
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/snoyberg/http-client";
    description = "An HTTP client engine, intended as a base layer for more user-friendly packages";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
