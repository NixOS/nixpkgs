{ cabal, pcre, regexBase }:

cabal.mkDerivation (self: {
  pname = "regex-pcre-builtin";
  version = "0.94.4.1.8.31";
  sha256 = "1g17yndavskv0v4zkpkqkl99ls03aqz028xcf5xvd3ak1q8mscx4";
  buildDepends = [ regexBase ];
  extraLibraries = [ pcre ];
  meta = {
    homepage = "http://hackage.haskell.org/package/regex-pcre";
    description = "Replaces/Enhances Text.Regex";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
