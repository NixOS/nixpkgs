{ callPackage, lib, ... }:

lib.overrideDerivation (callPackage ./generic-v3.nix {
  version = "3.2.0";
  sha256 = "120g0bg7ichry74allgmqnh7k0z2sdnrrfklb58b7szzn4zcdz14";
}) (attrs: { NIX_CFLAGS_COMPILE = "-Wno-error"; })
