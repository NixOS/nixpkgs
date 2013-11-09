{ cabal }:

cabal.mkDerivation (self: {
  pname = "cereal";
  version = "0.4.0.1";
  sha256 = "12g23cbjxxgh3xzv6hvs093zpycl29h8fmc7kv6jx43ws4cxy2jv";
  meta = {
    description = "A binary serialization library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
