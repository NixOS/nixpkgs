{ cabal }:

cabal.mkDerivation (self: {
  pname = "async";
  version = "1.3";
  sha256 = "0chpp8kfwccp57hl7mnralyn4s2x8f0vvkblmywfzb8sbdqgnril";
  meta = {
    homepage = "http://gitorious.org/async/";
    description = "Asynchronous Computations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
