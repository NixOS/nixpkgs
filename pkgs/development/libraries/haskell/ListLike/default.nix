{ cabal }:

cabal.mkDerivation (self: {
  pname = "ListLike";
  version = "3.1.1";
  sha256 = "16q1rsjr9rjlm8iwmr32s1yfcpw0xj34hvb8jfjqyfsail6nh9fh";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://software.complete.org/listlike";
    description = "Generic support for list-like structures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
