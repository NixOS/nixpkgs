{ cabal, base64Bytestring, blazeHtml, blazeMarkup, citeprocHs
, dataDefault, extensibleExceptions, filepath, highlightingKate
, HTTP, json, mtl, network, pandocTypes, parsec, random, syb
, tagsoup, temporary, texmath, text, time, xml, zipArchive, zlib
}:

cabal.mkDerivation (self: {
  pname = "pandoc";
  version = "1.10.1";
  sha256 = "127pxs1w99nr6hdancaajm20w3vgmch4xlj0v7221y7i9qcr1y1y";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    base64Bytestring blazeHtml blazeMarkup citeprocHs dataDefault
    extensibleExceptions filepath highlightingKate HTTP json mtl
    network pandocTypes parsec random syb tagsoup temporary texmath
    text time xml zipArchive zlib
  ];
  configureFlags = "-fblaze_html_0_5";
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
