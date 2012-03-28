{ cabal, regexBase }:

cabal.mkDerivation (self: {
  pname = "regex-posix";
  version = "0.94.4";
  sha256 = "1ykirysvz9ganm2k7fmrppklsgh0h35mjfsi9g1icv43pqpr6ldw";
  buildDepends = [ regexBase ];
  meta = {
    homepage = "http://sourceforge.net/projects/lazy-regex";
    description = "Replaces/Enhances Text.Regex";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
