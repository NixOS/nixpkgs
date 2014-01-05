{ cabal, caseInsensitive, httpClient, httpClientTls, httpTypes
, lens, liftedBase, monadControl, mtl, network, optparseApplicative
, transformers, transformersBase, xmlConduit, xmlHamlet
}:

cabal.mkDerivation (self: {
  pname = "DAV";
  version = "0.6";
  sha256 = "1lqc1w40mzj5gvpd3gc4qwgz3zrivwkz6ssa5592dsnwz81k1dxk";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    caseInsensitive httpClient httpClientTls httpTypes lens liftedBase
    monadControl mtl network optparseApplicative transformers
    transformersBase xmlConduit xmlHamlet
  ];
  meta = {
    homepage = "http://floss.scru.org/hDAV";
    description = "RFC 4918 WebDAV support";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
  };
})
