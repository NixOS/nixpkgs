{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.20";
  extraPatches = [ ./cygwin-4.4.patch ];
  sha256 = "0y9vsq8dkarx1mhhip1vaciz6imbbyv37c1dm8b20l7p064bg2i9";
})
