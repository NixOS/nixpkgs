{ cabal, base64Bytestring, blazeHtml, blazeMarkup, citeprocHs
, dataDefault, extensibleExceptions, filepath, highlightingKate
, HTTP, json, mtl, network, pandocTypes, parsec, random, syb
, tagsoup, temporary, texmath, text, time, xml, zipArchive, zlib
}:

cabal.mkDerivation (self: {
  pname = "pandoc";
  version = "1.10";
  sha256 = "11zvyzn16zckgs1zzhl415y14nziw16zhgghg31a459d1ww7c3dg";
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
