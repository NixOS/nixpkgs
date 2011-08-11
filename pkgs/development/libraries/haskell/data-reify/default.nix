{ cabal }:

cabal.mkDerivation (self: {
  pname = "data-reify";
  version = "0.6";
  sha256 = "0mif89mpj5zvw8czc51mfj27jw2ipxd2awnm9q13s46k6s5pv6a7";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://www.ittc.ku.edu/csdl/fpg/Tools/IOReification";
    description = "Reify a recursive data structure into an explicit graph";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
