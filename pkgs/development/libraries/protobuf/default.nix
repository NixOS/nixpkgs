{ lib, pkgs }:

lib.makeScope pkgs.newScope(self: with self; {
  protobuf = protobuf_24;

  protobuf_25 = callPackage ./generic.nix {
    version = "25.1";
    hash = "sha256-w6556kxftVZ154LrZB+jv9qK+QmMiUOGj6EcNwiV+yo=";
    abseil-cpp = pkgs.abseil-cpp_202308;
  };

  protobuf_24 = callPackage ./generic.nix {
    version = "24.4";
    hash = "sha256-I+Xtq4GOs++f/RlVff9MZuolXrMLmrZ2z6mkBayqQ2s=";
  };

  protobuf_23 = callPackage ./generic.nix {
    version = "23.4";
    hash = "sha256-eI+mrsZAOLEsdyTC3B+K+GjD3r16CmPx1KJ2KhCwFdg=";
  };

  protobuf_22 = callPackage ./generic.nix {
    version = "22.4";
    hash = "sha256-6G+TfXmE2frf5Okl5zxCOiT/V/+2meCoMLLPMrREUYk=";
  };

  protobuf_21 = callPackage ./generic.nix {
    version = "21.12";
    hash = "sha256-VZQEFHq17UsTH5CZZOcJBKiScGV2xPJ/e6gkkVliRCU=";
    abseil-cpp = pkgs.abseil-cpp_202103;
  };

  protobuf3_20 = callPackage ./generic-v3.nix {
    version = "3.20.3";
    sha256 = "sha256-u/1Yb8+mnDzc3OwirpGESuhjkuKPgqDAvlgo3uuzbbk=";
    abseil-cpp = pkgs.abseil-cpp_202103;
  };

  protobuf_3_20 = protobuf3_20;
})

