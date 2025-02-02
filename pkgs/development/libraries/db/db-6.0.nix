{ lib, stdenv, fetchurl, autoreconfHook, ... } @ args:

import ./generic.nix (args // {
  version = "6.0.30";
  sha256 = "1lhglbvg65j5slrlv7qv4vi3cvd7kjywa07gq1abzschycf4p3k0";
  license = lib.licenses.agpl3Only;
  extraPatches = [
    ./clang-6.0.patch
    ./CVE-2017-10140-cwd-db_config.patch
    ./darwin-mutexes.patch
  ];
})
