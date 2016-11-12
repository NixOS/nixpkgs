{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "5.3.28";
  sha256 = "0a1n5hbl7027fbz5lm0vp0zzfp1hmxnz14wx3zl9563h83br5ag0";
  branch = "5.3";
  # https://community.oracle.com/thread/3952592
  # this patch renames some sybols that conflict with libc++-3.8
  # symbols: atomic_compare_exchange, atomic_init, store
  extraPatches = [ ./clang-5.3.patch ];
})
