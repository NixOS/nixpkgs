{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "silently";
  version = "1.2.0.2";
  sha256 = "0qcprbjnh351hc9v12gww478qd4pw7wgpyjj1gmkx4mr80w0qmm1";
  buildDepends = [ deepseq ];
  meta = {
    homepage = "https://github.com/trystan/silently";
    description = "Prevent or capture writing to stdout and other handles";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
