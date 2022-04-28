{ lib, stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // {
  version = "4.8.30";
  sha256 = "0ampbl2f0hb1nix195kz1syrqqxpmvnvnfvphambj7xjrl3iljg0";
  extraPatches = [ ./clang-4.8.patch ./CVE-2017-10140-4.8-cwd-db_config.patch ];

  drvArgs.hardeningDisable = [ "format" ];
  drvArgs.doCheck = false;

  # crypto/aes_method.c:270 fails -Wformat-security.  This file is
  # included only in static builds.  It is not sufficient to add
  # hardeningDisable=["format"] -- that merely omits the
  # "-Wformat-security" flag.  To get the static build to complete we
  # must go further and disable it.
  drvArgs.NIX_CFLAGS_COMPILE = lib.optionals stdenv.hostPlatform.isStatic [ "-Wno-format-security" ];
})
