{ cabal, base64Bytestring, blazeHtml, Cabal, citeprocHs
, extensibleExceptions, filepath, highlightingKate, HTTP, json, mtl
, network, pandocTypes, parsec, random, syb, tagsoup, temporary
, texmath, time, utf8String, xml, zipArchive, zlib
}:

cabal.mkDerivation (self: {
  pname = "pandoc";
  version = "1.9.1.1";
  sha256 = "1npyc99f90fhbfddr6x5dlnwdc3i1pnhg4xiv12fmf1cl8xlcpyl";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    base64Bytestring blazeHtml Cabal citeprocHs extensibleExceptions
    filepath highlightingKate HTTP json mtl network pandocTypes parsec
    random syb tagsoup temporary texmath time utf8String xml zipArchive
    zlib
  ];
  configureFlags = "-fhighlighting -fthreaded";
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
