{ cabal }:

cabal.mkDerivation (self: {
  pname = "regex-base";
  version = "0.72.0.2";
  sha256 = "38a4901b942fea646a422d52c52ef14eec4d6561c258b3c54cd96a8a354141ee";
  meta = {
    homepage = "http://sourceforge.net/projects/lazy-regex";
    description = "Replaces/Enhances Text.Regex";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
