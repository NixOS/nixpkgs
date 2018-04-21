{ callPackage, lib, ... }:

lib.overrideDerivation (callPackage ./generic-v3.nix {
  version = "3.4.1";
  sha256 = "1lzxmbqlnmi34kymnf399azv86gmdbrf71xiad6wc24bzpkzqybb";
}) (attrs: { NIX_CFLAGS_COMPILE = "-Wno-error"; })
