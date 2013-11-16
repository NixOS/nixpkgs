{ cabal, network, openssl, time }:

cabal.mkDerivation (self: {
  pname = "HsOpenSSL";
  version = "0.10.3.5";
  sha256 = "1yvpvc9ylfqskdv0dqg6cl43w3wg7rggz0lwlrv04a45mrxygh80";
  buildDepends = [ network time ];
  extraLibraries = [ openssl ];
  meta = {
    homepage = "https://github.com/phonohawk/HsOpenSSL";
    description = "Partial OpenSSL binding for Haskell";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
