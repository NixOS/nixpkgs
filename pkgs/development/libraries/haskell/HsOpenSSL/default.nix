{ cabal, network, openssl, time }:

cabal.mkDerivation (self: {
  pname = "HsOpenSSL";
  version = "0.10.3";
  sha256 = "1f876xbx0a8xrs4ainmb79nisr6pflslzk26vk4psxgn9a159cvk";
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
