{ lib, stdenv, fetchurl, autoreconfHook, targetPlatform, ... } @ args:

import ./generic.nix (builtins.removeAttrs args ["targetPlatform"] // {
  version = "4.8.30";
  sha256 = "0ampbl2f0hb1nix195kz1syrqqxpmvnvnfvphambj7xjrl3iljg0";
  extraPatches = [
    ./clang-4.8.patch
    ./CVE-2017-10140-4.8-cwd-db_config.patch
    ./darwin-mutexes-4.8.patch
  ];

  drvArgs.configureFlags = lib.optional (targetPlatform.useLLVM or false) "--with-mutex=POSIX/pthreads";

  drvArgs.hardeningDisable = [ "format" ];
  drvArgs.doCheck = false;
})
