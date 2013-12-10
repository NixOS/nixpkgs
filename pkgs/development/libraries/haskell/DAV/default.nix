{ cabal, caseInsensitive, httpClient, httpConduit, httpTypes, lens
, liftedBase, mtl, network, optparseApplicative, resourcet
, transformers, xmlConduit, xmlHamlet
}:

cabal.mkDerivation (self: {
  pname = "DAV";
  version = "0.5";
  sha256 = "1yda3w8rr8p7jnpjpbjafis7xi01wmd1fwrq4fprzpfgghcjidhq";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    caseInsensitive httpClient httpConduit httpTypes lens liftedBase
    mtl network optparseApplicative resourcet transformers xmlConduit
    xmlHamlet
  ];
  meta = {
    homepage = "http://floss.scru.org/hDAV";
    description = "RFC 4918 WebDAV support";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
  };
})
