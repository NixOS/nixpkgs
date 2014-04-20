{ cabal, cgi, fastcgi, happstackServer, mtl, utf8String }:

cabal.mkDerivation (self: {
  pname = "happstack-fastcgi";
  version = "0.1.5";
  sha256 = "0rvb041nx2f8azvfy1yysisjqrmsfbxnccn992v5q7zhlglcvj8h";
  buildDepends = [ cgi fastcgi happstackServer mtl utf8String ];
  meta = {
    description = "Happstack extension for use with FastCGI";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.tomberek ];
  };
})
