{ cabal, base64Bytestring, cryptohash, random }:

cabal.mkDerivation (self: {
  pname = "pwstore-fast";
  version = "2.1";
  sha256 = "1gslxmipv3khv6fp6k62ip7fjn0jchzkhsqcdd8yrrkk8pdqdkya";
  buildDepends = [ base64Bytestring cryptohash random ];
  meta = {
    homepage = "https://github.com/PeterScott/pwstore";
    description = "Secure password storage";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
