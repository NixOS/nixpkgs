{cabal, RSA, SHA, aeson, attoparsec, base64Bytestring,
 blazeBuilder, caseInsensitive, enumerator, failure, httpEnumerator,
 httpTypes, network, tagsoup, text, tls, transformers,
 xmlEnumerator} :

cabal.mkDerivation (self : {
  pname = "authenticate";
  version = "0.9.2.2";
  sha256 = "0rn1f458ag9mmh55hi873xg5iqypwl6vf6blyaxwbgbp6nm327iz";
  propagatedBuildInputs = [
    RSA SHA aeson attoparsec base64Bytestring blazeBuilder
    caseInsensitive enumerator failure httpEnumerator httpTypes network
    tagsoup text tls transformers xmlEnumerator
  ];
  meta = {
    homepage = "http://github.com/snoyberg/authenticate/tree/master";
    description = "Authentication methods for Haskell web applications.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
