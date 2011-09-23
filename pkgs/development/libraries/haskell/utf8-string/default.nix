{ cabal }:

cabal.mkDerivation (self: {
  pname = "utf8-string";
  version = "0.3.7";
  sha256 = "1s59xsw1i311rpxb7arnd280pjqab5mrlfjmxbabknka8wqlnnvq";
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
