{ cabal, extensibleExceptions, HTTP, mtl, network, parsec, random
, syb, texmath, utf8String, xhtml, xml, zipArchive
}:

cabal.mkDerivation (self: {
  pname = "pandoc";
  version = "1.6.0.1";
  sha256 = "1imi6xkqzdy9y8kab04x8pn11r55j699apwrqvcz99j6f5g7xs9x";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    extensibleExceptions HTTP mtl network parsec random syb texmath
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
