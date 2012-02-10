{ cabal, base64Bytestring, blazeHtml, citeprocHs
, extensibleExceptions, highlightingKate, HTTP, json, mtl, network
, pandocTypes, parsec, random, syb, tagsoup, temporary, texmath
, time, utf8String, xml, zipArchive, zlib
}:

cabal.mkDerivation (self: {
  pname = "pandoc";
  version = "1.9.1";
  sha256 = "00xwy1afy4cn7z2drsc4dnqd4g45i45v9f3jm9j6i32pz27y8s2a";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    base64Bytestring blazeHtml citeprocHs extensibleExceptions
    highlightingKate HTTP json mtl network pandocTypes parsec random
    syb tagsoup temporary texmath time utf8String xml zipArchive zlib
  ];
  configureFlags = "-fhighlighting -fthreaded";
  meta = {
    homepage = "http://johnmacfarlane.net/pandoc";
    description = "Conversion between markup formats";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
