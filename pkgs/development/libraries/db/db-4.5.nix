{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.5.20";
  extraPatches = [ ./cygwin-4.5.patch ./register-race-fix.patch ];
  sha256 = "0bd81k0qv5i8w5gbddrvld45xi9k1gvmcrfm0393v0lrm37dab7m";
})
