{ cabal, caseInsensitive, either, errors, httpClient, httpClientTls
, httpTypes, lens, liftedBase, monadControl, mtl, network
, optparseApplicative, transformers, transformersBase, xmlConduit
, xmlHamlet
}:

cabal.mkDerivation (self: {
  pname = "DAV";
  version = "0.6.2";
  sha256 = "1alnjm0rfr7kwj6jax10bg8rcs8523n5dxyvw0mm65qykf78cprl";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    caseInsensitive either errors httpClient httpClientTls httpTypes
    lens liftedBase monadControl mtl network optparseApplicative
    transformers transformersBase xmlConduit xmlHamlet
  ];
  jailbreak = true;
  meta = {
    homepage = "http://floss.scru.org/hDAV";
    description = "RFC 4918 WebDAV support";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
  };
})
