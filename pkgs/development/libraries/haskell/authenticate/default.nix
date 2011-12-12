{ cabal, aeson, attoparsec, base64Bytestring, blazeBuilder
, caseInsensitive, enumerator, failure, httpEnumerator, httpTypes
, network, random, RSA, SHA, tagsoup, text, time, tls, transformers
, unorderedContainers, xmlEnumerator
}:

cabal.mkDerivation (self: {
  pname = "authenticate";
  version = "0.10.3.1";
  sha256 = "01xqqnvy2xjcgnp5qq5xiqm1whxywa31cgd79mm290i2r4baiq8s";
  buildDepends = [
    aeson attoparsec base64Bytestring blazeBuilder caseInsensitive
    enumerator failure httpEnumerator httpTypes network random RSA SHA
    tagsoup text time tls transformers unorderedContainers
    xmlEnumerator
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
