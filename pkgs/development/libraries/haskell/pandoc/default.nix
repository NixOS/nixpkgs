{ cabal, base64Bytestring, blazeHtml, citeprocHs
, extensibleExceptions, highlightingKate, HTTP, json, mtl, network
, pandocTypes, parsec, random, syb, tagsoup, temporary, texmath
, time, utf8String, xml, zipArchive, zlib
}:

cabal.mkDerivation (self: {
  pname = "pandoc";
  version = "1.9.0.2";
  sha256 = "0p1haqya99r52k6c07zq89ifdjs1r5g1y44011114pwsxwkmv43f";
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
