{ mkDerivation, base, ghc-prim, lib, pretty }:
mkDerivation {
  pname = "ghc-boot-th-next";
  version = "9.15";
  configureFlags = [ "-fbootstrap" ];
  libraryHaskellDepends = [ base ghc-prim pretty ];
  description = "Shared functionality between GHC and the template-haskell library";
  license = lib.licenses.bsd3;
}
