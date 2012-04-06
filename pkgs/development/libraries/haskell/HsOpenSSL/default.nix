{ cabal, network, openssl, time }:

cabal.mkDerivation (self: {
  pname = "HsOpenSSL";
  version = "0.10.2";
  sha256 = "0bji31lb9n08ybzs23251q6afr32fjvzcjm7qs3fvy3r7bc3gqbf";
  buildDepends = [ network time ];
  extraLibraries = [ openssl ];
  meta = {
    homepage = "https://github.com/phonohawk/HsOpenSSL";
    description = "(Incomplete) OpenSSL binding for Haskell";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
