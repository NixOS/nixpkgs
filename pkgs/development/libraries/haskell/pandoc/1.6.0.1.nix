{cabal, HTTP, mtl, network, parsec, syb, texmath, utf8String,
 xhtml, xml, zipArchive} :

cabal.mkDerivation (self : {
  pname = "pandoc";
  version = "1.6.0.1";
  sha256 = "1imi6xkqzdy9y8kab04x8pn11r55j699apwrqvcz99j6f5g7xs9x";
  propagatedBuildInputs = [
    HTTP mtl network parsec syb texmath utf8String xhtml xml zipArchive
  ];
  meta = {
    homepage = "http://johnmacfarlane.net/pandoc";
    description = "Conversion between markup formats";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
