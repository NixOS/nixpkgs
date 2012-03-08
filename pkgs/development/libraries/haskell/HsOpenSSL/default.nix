{ cabal, network, openssl, time }:

cabal.mkDerivation (self: {
  pname = "HsOpenSSL";
  version = "0.10.1.4";
  sha256 = "1zrmngxm1xs51ql5za46lw6xkiyczx6qyvpami9k13g8k6kznqbz";
  buildDepends = [ network time ];
  extraLibraries = [ openssl ];
  meta = {
    homepage = "https://github.com/phonohawk/HsOpenSSL";
    description = "(Incomplete) OpenSSL binding for Haskell";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
