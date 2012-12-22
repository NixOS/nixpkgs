{ cabal, libxml2, text, xmlTypes }:

cabal.mkDerivation (self: {
  pname = "libxml-sax";
  version = "0.7.3";
  sha256 = "1514ix5n8y1dwjdm0kmr17fdigc0ic89gzwdvfgh542sjm11100r";
  buildDepends = [ text xmlTypes ];
  extraLibraries = [ libxml2 ];
  pkgconfigDepends = [ libxml2 ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-libxml/";
    description = "Bindings for the libXML2 SAX interface";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
