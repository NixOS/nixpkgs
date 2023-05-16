<<<<<<< HEAD
{ lib, stdenv, fetchurl, autoreconfHook, ... } @ args:
=======
{ lib, stdenv, fetchurl, ... } @ args:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

import ./generic.nix (args // {
  version = "6.0.20";
  sha256 = "00r2aaglq625y8r9xd5vw2y070plp88f1mb2gbq3kqsl7128lsl0";
  license = lib.licenses.agpl3;
<<<<<<< HEAD
  extraPatches = [
    ./clang-6.0.patch
    ./CVE-2017-10140-cwd-db_config.patch
    ./darwin-mutexes.patch
  ];
=======
  extraPatches = [ ./clang-6.0.patch ./CVE-2017-10140-cwd-db_config.patch ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
})
