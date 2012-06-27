{ cabal, base64Bytestring, blazeHtml, citeprocHs
, extensibleExceptions, filepath, highlightingKate, HTTP, json, mtl
, network, pandocTypes, parsec, random, syb, tagsoup, temporary
, texmath, time, utf8String, xml, zipArchive, zlib
}:

cabal.mkDerivation (self: {
  pname = "pandoc";
  version = "1.9.4.1";
  sha256 = "0n3jfk7b1vn8b1ryys6lm1drdx469q26gi0chzlf0wss1ss07x78";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    base64Bytestring blazeHtml citeprocHs extensibleExceptions filepath
    highlightingKate HTTP json mtl network pandocTypes parsec random
    syb tagsoup temporary texmath time utf8String xml zipArchive zlib
  ];
  meta = {
    homepage = "http://johnmacfarlane.net/pandoc";
    description = "Conversion between markup formats";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
