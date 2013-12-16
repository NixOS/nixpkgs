{ cabal, caseInsensitive, httpClient, httpClientTls, httpTypes
, lens, liftedBase, mtl, network, optparseApplicative, resourcet
, transformers, xmlConduit, xmlHamlet
}:

cabal.mkDerivation (self: {
  pname = "DAV";
  version = "0.5.1";
  sha256 = "12r5hy6g5k5bdf3n84hpq9b90nz6v2v3xwy7prxkvv99iaxf2lsj";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    caseInsensitive httpClient httpClientTls httpTypes lens liftedBase
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
