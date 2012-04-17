{ cabal, filepath, libX11, mesa, parsec, stm, time, wxc, wxdirect
, wxGTK
}:

cabal.mkDerivation (self: {
  pname = "wxcore";
  version = "0.90";
  sha256 = "1vrv683576cdvxfiriw2aw5kw1gzrddd27pxa06rrg5nny0jni46";
  buildDepends = [ filepath parsec stm time wxc wxdirect ];
  extraLibraries = [ libX11 mesa wxGTK ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/WxHaskell";
    description = "wxHaskell core";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
