{ cabal, libX11, mesa, wxdirect, wxGTK }:

cabal.mkDerivation (self: {
  pname = "wxc";
  version = "0.90.1.1";
  sha256 = "0cvfphskvsq3lsl24h6jh8r6yw5jg8qa9wdc883yasfvmzmxwwgc";
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
