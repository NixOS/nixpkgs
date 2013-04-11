{ cabal, libxml2, text, xmlTypes }:

cabal.mkDerivation (self: {
  pname = "libxml-sax";
  version = "0.7.4";
  sha256 = "1vbxrmxxb6a58hd6dd81kz8fh198jkvwv4gxzbbfw44170946c0z";
  buildDepends = [ text xmlTypes ];
  extraLibraries = [ libxml2 ];
  pkgconfigDepends = [ libxml2 ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-libxml/";
    description = "Bindings for the libXML2 SAX interface";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
