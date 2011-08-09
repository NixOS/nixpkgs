{ cabal }:

cabal.mkDerivation (self: {
  pname = "utf8-string";
  version = "0.3.6";
  sha256 = "c8c74555174edfb96145585c9b80780d0fc55ba249282b8a4c5968cca7c09d69";
  meta = {
    homepage = "http://github.com/glguy/utf8-string/";
    description = "Support for reading and writing UTF8 Strings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
