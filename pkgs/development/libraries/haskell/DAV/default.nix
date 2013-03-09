{ cabal, caseInsensitive, cmdargs, httpConduit, httpTypes, lens
, liftedBase, mtl, network, resourcet, transformers, xmlConduit
, xmlHamlet
}:

cabal.mkDerivation (self: {
  pname = "DAV";
  version = "0.3.1";
  sha256 = "0ql6sf61gq55iyn189papnid91n4ab5s2i24zvkqrgixjz7998rd";
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
