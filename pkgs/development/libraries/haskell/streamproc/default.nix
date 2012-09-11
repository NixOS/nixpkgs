{ cabal }:

cabal.mkDerivation (self: {
  pname = "streamproc";
  version = "1.6";
  sha256 = "0bb1rdzzpjggw7dk4q3hwa1j1bvkfqhz6vrd45shcp57ixqlp6ws";
  meta = {
    homepage = "http://gitorious.org/streamproc";
    description = "Stream Processer Arrow";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
