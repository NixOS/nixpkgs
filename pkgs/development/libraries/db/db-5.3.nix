{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  ...
}@args:

import ./generic.nix (
  args
  // {
    version = "5.3.28";
    sha256 = "0a1n5hbl7027fbz5lm0vp0zzfp1hmxnz14wx3zl9563h83br5ag0";
    extraPatches = [
      ./clang-5.3.patch
      ./CVE-2017-10140-cwd-db_config.patch
      ./darwin-mutexes.patch
    ];
  }
)
