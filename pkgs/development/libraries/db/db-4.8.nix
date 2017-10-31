{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.8.30";
  sha256 = "0ampbl2f0hb1nix195kz1syrqqxpmvnvnfvphambj7xjrl3iljg0";
  extraPatches = [ ./clang-4.8.patch ];

  drvArgs.hardeningDisable = [ "format" ];
  drvArgs.doCheck = false;
})
