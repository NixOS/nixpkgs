{ cabal, caseInsensitive, cmdargs, httpConduit, httpTypes, lens
, liftedBase, mtl, network, resourcet, transformers, xmlConduit
, xmlHamlet
}:

cabal.mkDerivation (self: {
  pname = "DAV";
  version = "0.3";
  sha256 = "16qbq59g79a0a1n6vblndj1fknj9fvd0anhrsz9czwl3k3lk5cx8";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    caseInsensitive cmdargs httpConduit httpTypes lens liftedBase mtl
    network resourcet transformers xmlConduit xmlHamlet
  ];
  meta = {
    homepage = "http://floss.scru.org/hDAV";
    description = "RFC 4918 WebDAV support";
    license = self.stdenv.lib.licenses.gpl3;
    platforms = self.ghc.meta.platforms;
  };
})
