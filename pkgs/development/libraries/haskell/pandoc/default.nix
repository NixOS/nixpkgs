{ cabal, base64Bytestring, blazeHtml, citeprocHs
, extensibleExceptions, filepath, highlightingKate, HTTP, json, mtl
, network, pandocTypes, parsec, random, syb, tagsoup, temporary
, texmath, time, utf8String, xml, zipArchive, zlib
}:

cabal.mkDerivation (self: {
  pname = "pandoc";
  version = "1.9.4";
  sha256 = "0rqj9a3pkbhlqsmpxvjzahn992lm1pdg1bry677y8f5203ji10p2";
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
