{ cabal, libX11, mesa, wxdirect, wxGTK }:

cabal.mkDerivation (self: {
  pname = "wxc";
  version = "0.90.0.4";
  sha256 = "1bh20i1rb8ng0ni1v98nm8qv5wni19dvxwf5i3ijxhrxqdq4i7p6";
  buildDepends = [ wxdirect ];
  extraLibraries = [ libX11 mesa wxGTK ];
  postInstall = ''
    cp -v dist/build/libwxc.so.${self.version} $out/lib/libwxc.so
  '';
  patches = [ ./fix-bogus-pointer-assignment.patch ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/WxHaskell";
    description = "wxHaskell C++ wrapper";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
