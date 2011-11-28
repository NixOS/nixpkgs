{ cabal, aeson, attoparsec, base64Bytestring, blazeBuilder
, caseInsensitive, enumerator, failure, httpEnumerator, httpTypes
, network, random, RSA, SHA, tagsoup, text, time, tls, transformers
, xmlEnumerator
}:

cabal.mkDerivation (self: {
  pname = "authenticate";
  version = "0.10.3";
  sha256 = "1sp8yanb8wray3pnakaj7jqsxirjw6ds2f1j2p72p9hn3kcf4255";
  buildDepends = [
    aeson attoparsec base64Bytestring blazeBuilder caseInsensitive
    enumerator failure httpEnumerator httpTypes network random RSA SHA
    tagsoup text time tls transformers xmlEnumerator
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
