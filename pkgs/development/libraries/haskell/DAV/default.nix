{ cabal, caseInsensitive, cmdargs, httpConduit, httpTypes, lens
, liftedBase, mtl, network, resourcet, transformers, xmlConduit
, xmlHamlet
}:

cabal.mkDerivation (self: {
  pname = "DAV";
  version = "0.2";
  sha256 = "0g9b72ia4h85ykbng6103wc8f218fj9fdvm1896yx999vr95kxw4";
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
