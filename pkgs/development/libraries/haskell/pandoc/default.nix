{ cabal, base64Bytestring, blazeHtml, blazeMarkup, citeprocHs
, dataDefault, extensibleExceptions, filepath, highlightingKate
, HTTP, json, mtl, network, pandocTypes, parsec, random, syb
, tagsoup, temporary, texmath, text, time, xml, zipArchive, zlib
}:

cabal.mkDerivation (self: {
  pname = "pandoc";
  version = "1.10.0.5";
  sha256 = "05mjgvxk3wxfssf4aviigdm6jb73a6bp8lwz86aabdgkgh2i6n54";
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
