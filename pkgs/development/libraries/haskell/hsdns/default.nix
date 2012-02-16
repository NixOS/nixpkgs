{ cabal, adns, Cabal, network }:

cabal.mkDerivation (self: {
  pname = "hsdns";
  version = "1.5";
  sha256 = "2788d1ad5ef07ae5f356a460fb92316118f3a4d9c779ec27fb8243602bcf6399";
  buildDepends = [ Cabal network ];
  extraLibraries = [ adns ];
  noHaddock = true;
  meta = {
    homepage = "http://gitorious.org/hsdns";
    description = "Asynchronous DNS Resolver";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
