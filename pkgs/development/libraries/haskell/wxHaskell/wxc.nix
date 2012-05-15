{ cabal, libX11, mesa, wxdirect, wxGTK }:

cabal.mkDerivation (self: {
  pname = "wxc";
  version = "0.90.0.3";
  sha256 = "14b8g2w4knwxj5vkp759y8m3nmsi4n1zy57ma1kz7lw6jklb7dlq";
  buildDepends = [ wxdirect ];
  extraLibraries = [ libX11 mesa wxGTK ];
  noHaddock = true;
  postInstall = ''
    cp -v dist/build/libwxc.so.${self.version} $out/lib/libwxc.so
  '';

  meta = {
    homepage = "http://haskell.org/haskellwiki/WxHaskell";
    description = "wxHaskell C++ wrapper";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
