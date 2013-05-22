{ cabal, caseInsensitive, httpConduit, httpTypes, lens, liftedBase
, mtl, network, optparseApplicative, resourcet, transformers
, xmlConduit, xmlHamlet
}:

cabal.mkDerivation (self: {
  pname = "DAV";
  version = "0.4.1";
  sha256 = "0bcrnlixrzvbdvw7ffv2xl2d0k0w71jf0i5ayf97ymxly8ii8s0c";
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
  };
})
