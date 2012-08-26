{ cabal, base64Bytestring, blazeHtml, citeprocHs
, extensibleExceptions, filepath, highlightingKate, HTTP, json, mtl
, network, pandocTypes, parsec, random, syb, tagsoup, temporary
, texmath, time, utf8String, xml, zipArchive, zlib
}:

cabal.mkDerivation (self: {
  pname = "pandoc";
  version = "1.9.4.2";
  sha256 = "1zr2qx6bimyhzia5maqpb454hgdwjvgs234mcki4f1z3dgbq0lsk";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    base64Bytestring blazeHtml citeprocHs extensibleExceptions filepath
    highlightingKate HTTP json mtl network pandocTypes parsec random
    syb tagsoup temporary texmath time utf8String xml zipArchive zlib
  ];
  patchPhase = ''
    sed -i -e 's|base64-bytestring.*,|base64-bytestring,|' pandoc.cabal
  '';
  meta = {
    homepage = "http://johnmacfarlane.net/pandoc";
    description = "Conversion between markup formats";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
