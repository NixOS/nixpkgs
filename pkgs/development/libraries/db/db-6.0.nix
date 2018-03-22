{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "6.0.20";
  sha256 = "00r2aaglq625y8r9xd5vw2y070plp88f1mb2gbq3kqsl7128lsl0";
  license = stdenv.lib.licenses.agpl3;
  extraPatches = [ ./clang-6.0.patch ./CVE-2017-10140-cwd-db_config.patch ];
})
