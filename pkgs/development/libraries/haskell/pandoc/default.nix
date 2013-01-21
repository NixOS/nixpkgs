{ cabal, base64Bytestring, blazeHtml, blazeMarkup, citeprocHs
, dataDefault, extensibleExceptions, filepath, highlightingKate
, HTTP, json, mtl, network, pandocTypes, parsec, random, syb
, tagsoup, temporary, texmath, text, time, xml, zipArchive, zlib
}:

cabal.mkDerivation (self: {
  pname = "pandoc";
  version = "1.10.0.4";
  sha256 = "1zwjwzxgip3zhbs7v7i981f5ch1rrd8i04cmn1gkfxnapbxx6z26";
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
