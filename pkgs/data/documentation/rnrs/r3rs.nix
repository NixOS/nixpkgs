{ fetchurl, stdenv, texinfo }:

import ./common.nix {
  inherit fetchurl stdenv texinfo;
  revision = 3;
  sha256 = "0knrpkr74s8yn4xcqxkqpgxmzdmzrvahh1n1csqc1wwd2rb4vnpr";
}
