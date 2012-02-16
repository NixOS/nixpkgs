{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "GlomeVec";
  version = "0.1.2";
  sha256 = "6023c11977bf16baf487235087e94f5a2f465e8403b8e40ab513e7879dd52639";
  buildDepends = [ Cabal ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Glome";
    description = "Simple 3D vector library";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
