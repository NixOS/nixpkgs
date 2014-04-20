{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.7.25";
  sha256 = "0gi667v9cw22c03hddd6xd6374l0pczsd56b7pba25c9sdnxjkzi";
})
