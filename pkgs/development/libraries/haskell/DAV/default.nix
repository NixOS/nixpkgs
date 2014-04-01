{ cabal, caseInsensitive, either, errors, httpClient, httpClientTls
, httpTypes, lens, liftedBase, monadControl, mtl, network
, optparseApplicative, transformers, transformersBase, xmlConduit
, xmlHamlet
}:

cabal.mkDerivation (self: {
  pname = "DAV";
  version = "0.6.1";
  sha256 = "0j82fz5z9cwnl41qqs69gv0li25rkjndd8lnf4zy7bbdy558nxgz";
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
