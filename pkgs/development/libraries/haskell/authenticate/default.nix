{ cabal, aeson, attoparsec, base64Bytestring, blazeBuilder
, caseInsensitive, enumerator, failure, httpEnumerator, httpTypes
, network, random, RSA, SHA, tagsoup, text, time, tls, transformers
, unorderedContainers, xmlEnumerator
}:

cabal.mkDerivation (self: {
  pname = "authenticate";
  version = "0.10.4";
  sha256 = "0bjxlnc2qf1900ch9cnab26qz6a0vdz5nz1dwrjby1n5xqqzjd7x";
  buildDepends = [
    aeson attoparsec base64Bytestring blazeBuilder caseInsensitive
    enumerator failure httpEnumerator httpTypes network random RSA SHA
    tagsoup text time tls transformers unorderedContainers
    xmlEnumerator
  ];
  meta = {
    homepage = "http://github.com/yesodweb/authenticate";
    description = "Authentication methods for Haskell web applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
