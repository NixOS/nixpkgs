{ cabal, network, openssl, time }:

cabal.mkDerivation (self: {
  pname = "HsOpenSSL";
  version = "0.10.3.4";
  sha256 = "1xgnzivphnzb4yf31406yg5fjycrfypwrlxi2s8lfzgja8m1l7h5";
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
