{ cabal, caseInsensitive, httpConduit, httpTypes, lens, liftedBase
, mtl, network, optparseApplicative, resourcet, transformers
, xmlConduit, xmlHamlet
}:

cabal.mkDerivation (self: {
  pname = "DAV";
  version = "0.4";
  sha256 = "10iwhxq9dbyx3j873khwkjxkhz9p1b1qms7q25jnpk15p1ph8b4a";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    caseInsensitive httpConduit httpTypes lens liftedBase mtl network
    optparseApplicative resourcet transformers xmlConduit xmlHamlet
  ];
  meta = {
    homepage = "http://floss.scru.org/hDAV";
    description = "RFC 4918 WebDAV support";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
