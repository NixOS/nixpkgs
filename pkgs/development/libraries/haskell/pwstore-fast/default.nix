{ cabal, base64Bytestring, cryptohash, random }:

cabal.mkDerivation (self: {
  pname = "pwstore-fast";
  version = "2.3";
  sha256 = "014l4n00lpg5037fkdwnxnv7xjfc3vlz1dphr7hfbqnjwf1z9ibw";
  buildDepends = [ base64Bytestring cryptohash random ];
  meta = {
    homepage = "https://github.com/PeterScott/pwstore";
    description = "Secure password storage";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
