{ cabal, base64Bytestring, cryptohash, random }:

cabal.mkDerivation (self: {
  pname = "pwstore-fast";
  version = "2.2";
  sha256 = "03b9vr5j6cadvi6w3lr8b9km4jq6jh0vzcmkxzq9qvvly89lx96a";
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
