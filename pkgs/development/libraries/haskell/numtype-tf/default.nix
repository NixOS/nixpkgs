{ cabal }:

cabal.mkDerivation (self: {
  pname = "numtype-tf";
  version = "0.1.1";
  sha256 = "0aj24jlfcv4rsa0zfglsfgq9f0kxln32drypp66652ycffz3ip9a";
  meta = {
    homepage = "http://dimensional.googlecode.com/";
    description = "Type-level (low cardinality) integers, implemented using type families";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
