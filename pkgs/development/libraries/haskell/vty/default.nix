{ cabal, deepseq, mtl, parallel, parsec, terminfo, utf8String
, vector
}:

cabal.mkDerivation (self: {
  pname = "vty";
  version = "4.7.0.10";
  sha256 = "03cvr4z0fvxfyrikgf89777cp1xqhy22yj83p0dysp0i5ds6cd9v";
  buildDepends = [
    deepseq mtl parallel parsec terminfo utf8String vector
  ];
  meta = {
    homepage = "https://github.com/coreyoconnor/vty";
    description = "A simple terminal access library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
