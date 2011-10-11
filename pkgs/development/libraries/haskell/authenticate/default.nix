{ cabal, aesonNative, attoparsec, base64Bytestring, blazeBuilder
, caseInsensitive, enumerator, failure, httpEnumerator, httpTypes
, network, random, RSA, SHA, tagsoup, text, time, tls, transformers
, xmlEnumerator
}:

cabal.mkDerivation (self: {
  pname = "authenticate";
  version = "0.10.2.2";
  sha256 = "10w13wcd8cwaf4ifxllsiijwza2ys4a5zyhjcbl4938609p60hi8";
  buildDepends = [
    aesonNative attoparsec base64Bytestring blazeBuilder
    caseInsensitive enumerator failure httpEnumerator httpTypes network
    random RSA SHA tagsoup text time tls transformers xmlEnumerator
  ];
  meta = {
    homepage = "http://github.com/snoyberg/authenticate/tree/master";
    description = "Authentication methods for Haskell web applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
