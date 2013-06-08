{ cabal }:

cabal.mkDerivation (self: {
  pname = "parseargs";
  version = "0.1.3.5";
  sha256 = "1ig1n2nnicmy71qwcl5hkdk4mvwq0mz6zr5h9kw329lgvr9cyzyc";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://wiki.cs.pdx.edu/bartforge/parseargs";
    description = "Command-line argument parsing library for Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
