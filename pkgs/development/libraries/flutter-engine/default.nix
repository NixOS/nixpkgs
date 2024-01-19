{ lib, callPackage, fetchzip }:
with lib;
let
  mkCustomEngine = args: callPackage ./package.nix args;

  mkEngine = { version, dartVersion, hash }:
    let
      args = {
        inherit version dartVersion hash;

        url = "https://github.com/flutter/engine.git@${version}";
      };
    in (mkCustomEngine args).overrideAttrs (f: p: {
      meta = p.meta // {
        platforms = attrNames hash;
      };
    });
in
{
  inherit mkEngine;

  stable = mkEngine {
    version = "a794cf2681c6c9fe7b260e0e84de96298dc9c18b";
    dartVersion = "3.1.3";
    hash = {
      x86_64-linux = "sha256-J52xmyRiTBTfvsW2b4QROsI4G/KEggX7LRL8F1Cp5b8=";
      aarch64-linux = "sha256-QEDA0hezbPF5vwfpUp25KQjVxL9ULwv2XDo61b9sQTE=";
    };
  };
}
