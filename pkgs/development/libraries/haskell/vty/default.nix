{ cabal, deepseq, mtl, parallel, parsec, terminfo, utf8String
, vector
}:

cabal.mkDerivation (self: {
  pname = "vty";
  version = "4.7.0.6";
  sha256 = "1jb7c4wh8pjb5salh725vxjbx29wy6ph5gvdp177piq40v3zvbg3";
  buildDepends = [
    deepseq mtl parallel parsec terminfo utf8String vector
  ];
  meta = {
    homepage = "https://github.com/coreyoconnor/vty";
    description = "A simple terminal access library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
