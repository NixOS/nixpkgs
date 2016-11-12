{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.8.30";
  extraPatches = [ ./clang-4.8.patch ];
  sha256 = "0ampbl2f0hb1nix195kz1syrqqxpmvnvnfvphambj7xjrl3iljg0";
  branch = "4.8";
  drvArgs.hardeningDisable = [ "format" ];

  # https://community.oracle.com/thread/3952592
  # this patch renames some sybols that conflict with libc++-3.8
  # symbols: atomic_compare_exchange, atomic_init, store
  drvArgs.prePatch = ''
    substituteInPlace dbinc/db.in \
      --replace '#define	store' '#define	store_db'

    substituteInPlace dbinc/atomic.h \
      --replace atomic_compare_exchange atomic_compare_exchange_db \
      --replace atomic_init atomic_init_db
    substituteInPlace mp/*.c \
      --replace atomic_compare_exchange atomic_compare_exchange_db \
      --replace atomic_init atomic_init_db
    substituteInPlace mutex/*.c \
      --replace atomic_compare_exchange atomic_compare_exchange_db \
      --replace atomic_init atomic_init_db
  '';
})
