{ cabal, blazeBuilder, happy, mtl, utf8Light, utf8String }:

cabal.mkDerivation (self: {
  pname = "language-javascript";
  version = "0.5.4";
  sha256 = "0hjx12n3pkxcdkppqalv6sl68vjlib37gby89ksay807ndslvb9q";
  buildDepends = [ blazeBuilder mtl utf8Light utf8String ];
  buildTools = [ happy ];
  meta = {
    homepage = "http://github.com/alanz/language-javascript";
    description = "Parser for JavaScript";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
