{ mkDerivation, aeson, base, bytestring, Cabal, containers, deepseq
, hspec, language-nix, lens, lib, pretty, process, split
}:
mkDerivation {
  pname = "distribution-nixpkgs";
  version = "1.6.0";
  sha256 = "d1804dcb731858d40859f1cf55ea81b3f6bc63a353437c1009c158e0f9e03354";
  revision = "1";
  editedCabalFile = "0j35y7ws7rbc68vkmyvpa4m2dyfpzpzzvm4lv7h6r7x34w331dgg";
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson base bytestring Cabal containers deepseq language-nix lens
    pretty process split
  ];
  testHaskellDepends = [ base deepseq hspec lens ];
  homepage = "https://github.com/NixOS/distribution-nixpkgs";
  description = "Types and functions to manipulate the Nixpkgs distribution";
  license = lib.licenses.bsd3;
}
