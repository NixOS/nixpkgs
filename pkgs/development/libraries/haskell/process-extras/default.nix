{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "process-extras";
  version = "0.1.0";
  sha256 = "0bq8nz2iapmngmkx2vlyk4ffw20b34yw5q7h7j6r3zrjzq42prsp";
  buildDepends = [ text ];
  meta = {
    homepage = "https://github.com/davidlazar/process-extras";
    description = "Process extras";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
