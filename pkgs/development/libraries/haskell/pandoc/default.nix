{ cabal, base64Bytestring, blazeHtml, citeprocHs
, extensibleExceptions, highlightingKate, HTTP, json, mtl, network
, pandocTypes, parsec, random, syb, tagsoup, temporary, texmath
, time, utf8String, xml, zipArchive, zlib
}:

cabal.mkDerivation (self: {
  pname = "pandoc";
  version = "1.9.0.5";
  sha256 = "0haszw0khz47k2cfhzz38ia1zznwwmixhaf0jyr6l2gdpfq59b0p";
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
