{ cabal, base64Bytestring, blazeHtml, citeprocHs
, extensibleExceptions, filepath, highlightingKate, HTTP, json, mtl
, network, pandocTypes, parsec, random, syb, tagsoup, temporary
, texmath, time, utf8String, xml, zipArchive, zlib
}:

cabal.mkDerivation (self: {
  pname = "pandoc";
  version = "1.9.2";
  sha256 = "1hp51ddfwlg4pg5n16jhf7w8r4s074n5baiy55fi2p47lx278jsq";
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
