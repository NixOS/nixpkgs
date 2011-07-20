{cabal, adns, network}:

cabal.mkDerivation (self : {
  pname = "hsdns";
  version = "1.5";
  sha256 = "2788d1ad5ef07ae5f356a460fb92316118f3a4d9c779ec27fb8243602bcf6399";
  propagatedBuildInputs = [adns network];
  meta = {
    description = "an asynchronous DNS resolver on top of GNU ADNS";
    license = "LGPL";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

