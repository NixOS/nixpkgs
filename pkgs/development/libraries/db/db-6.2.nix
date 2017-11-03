{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "6.2.23";
  sha256 = "1isxx4jfmnh913jzhp8hhfngbk6dsg46f4kjpvvc56maj64jqqa7";
  license = stdenv.lib.licenses.agpl3;
  extraPatches = [ ./clang-6.0.patch ./CVE-2017-10140-cwd-db_config.patch ];
})
