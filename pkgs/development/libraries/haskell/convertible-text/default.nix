{ cabal, attempt, text, time }:

cabal.mkDerivation (self: {
  pname = "convertible-text";
  version = "0.3.0.10";
  sha256 = "1hi7rqijay37b5msyzqqgvkvrsdpj9p96ajxmyk4vm7nnk5dfhbp";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ attempt text time ];
  meta = {
    homepage = "http://github.com/snoyberg/convertible/tree/text";
    description = "Typeclasses and instances for converting between types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
