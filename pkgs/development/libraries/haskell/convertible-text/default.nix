{ cabal, attempt, text, time }:

cabal.mkDerivation (self: {
  pname = "convertible-text";
  version = "0.4.0.1";
  sha256 = "0m252ml2zgw0jxfs678m1wp9ivy6gvi9w50qw7zi9ycxnzj9j6r2";
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
