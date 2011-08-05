{cabal, adns, network}:

cabal.mkDerivation (self : {
  pname = "hsdns";
  version = "1.5";
  sha256 = "2788d1ad5ef07ae5f356a460fb92316118f3a4d9c779ec27fb8243602bcf6399";
  propagatedBuildInputs = [adns network];
  noHaddock = true; /* the build fails for reasons I don't understand. */
  meta = {
    homepage = "http://gitorious.org/hsdns";
    description = "Asynchronous DNS Resolver";
    license = self.stdenv.lib.licenses.lgpl3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [self.stdenv.lib.maintainers.simons];
  };
})
