# FREEBSD-SPECIFIC OVERRIDES FOR THE HASKELL PACKAGE SET IN NIXPKGS

{ pkgs, haskellLib }:

let
  inherit (pkgs) lib darwin;
in

with haskellLib;

self: super: ({
  # this can be removed when we get time-compat v1.9.7
  # fix: https://github.com/haskellari/time-compat/commit/cb7ab16ee80e28cd2c611e274305d9173b9a0b33
  time-compat = dontCheck super.time-compat;
})
