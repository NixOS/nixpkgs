<<<<<<< HEAD
{ lib, stdenv, fetchurl, autoreconfHook, ... } @ args:
=======
{ lib, stdenv, fetchurl, ... } @ args:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

import ./generic.nix (args // {
  version = "6.2.23";
  sha256 = "1isxx4jfmnh913jzhp8hhfngbk6dsg46f4kjpvvc56maj64jqqa7";
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
