{ callPackage, lib, ... }:

lib.overrideDerivation (callPackage ./generic-v3.nix {
  version = "3.4.0";
  sha256 = "0385j54kgr71h0cxh5vqr81qs57ack2g2k9mcdbq188v4ckjacyx";
}) (attrs: { NIX_CFLAGS_COMPILE = "-Wno-error"; })
