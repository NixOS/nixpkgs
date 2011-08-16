{ cabal, base64Bytestring, citeprocHs, dlist, extensibleExceptions
, HTTP, json, mtl, network, pandocTypes, parsec, random, syb
, tagsoup, texmath, utf8String, xhtml, xml, zipArchive
}:

cabal.mkDerivation (self: {
  pname = "pandoc";
  version = "1.8.2.1";
  sha256 = "0cwly0j2rj46h654iwl04l6jkhk6rrhynqvrdnq47067n9vm60pi";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    base64Bytestring citeprocHs dlist extensibleExceptions HTTP json
    mtl network pandocTypes parsec random syb tagsoup texmath
    utf8String xhtml xml zipArchive
  ];
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
