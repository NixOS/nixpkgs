{ cabal, base64Bytestring, blazeHtml, blazeMarkup, citeprocHs
, extensibleExceptions, filepath, highlightingKate, HTTP, json, mtl
, network, pandocTypes, parsec, random, syb, tagsoup, temporary
, texmath, time, utf8String, xml, zipArchive, zlib
}:

cabal.mkDerivation (self: {
  pname = "pandoc";
  version = "1.9.4.5";
  sha256 = "05k8i537756m07xlb6kgshpfxa4sp2jxidb1c8m72ilpai13r6fb";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    base64Bytestring blazeHtml blazeMarkup citeprocHs
    extensibleExceptions filepath highlightingKate HTTP json mtl
    network pandocTypes parsec random syb tagsoup temporary texmath
    time utf8String xml zipArchive zlib
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
