{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.8.30";
  extraPatches = [ ./clang-4.8.patch ];
  sha256 = "0ampbl2f0hb1nix195kz1syrqqxpmvnvnfvphambj7xjrl3iljg0";
  branch = "4.8";
  drvArgs = { hardeningDisable = [ "format" ]; };
})
