{ mkDerivation, base, fetchzip, lib, template-haskell }:
mkDerivation {
  pname = "template-haskell-lift";
  version = "0.1.0.0";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/template-haskell-lift-0.1.0.0/template-haskell-lift-0.1.0.0.tar.gz";
    sha256 = "0rgfsb9r9wa647xxcdixi11mwk2rrncwx953zlga05jyy1kzlygf";
  };
  libraryHaskellDepends = [ base template-haskell ];
  description = "The 'Lift' typeclass";
  license = lib.meta.getLicenseFromSpdxId "BSD-2-Clause";
}
