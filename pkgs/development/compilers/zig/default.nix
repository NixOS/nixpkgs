{
  lib,
  darwin,
  callPackage,
  llvmPackages_13,
  llvmPackages_15,
  llvmPackages_16,
  llvmPackages_17,
  llvmPackages_18,
  zigVersions ? { },
  isBootstrap ? false,
}:
let
  versions = {
    "0.9.0" = {
      llvmPackages = llvmPackages_13;
      hash = "sha256-x2c4c9RSrNWGqEngio4ArW7dJjW0gg+8nqBwPcR721k=";
      bootstrapHashes = {
        "linux-aarch64" = "sha256:00m6nxp64nf6pwq407by52l8i0f2m4mw6hj17jbjdjd267b6sgri";
        "linux-x86_64" = "sha256:1vagp72wxn6i9qscji6k3a1shy76jg4d6crmx9ijpch9kyn71c96";
      };
    };
    "0.10.0" = {
      llvmPackages = llvmPackages_15;
      hash = "sha256-69QIkkKzApOGfrBdgtmxFMDytRkSh+0YiaJQPbXsBeo=";
      bootstrapHashes = {
        "linux-aarch64" = "sha256:1pd962kapmjqkf60fidmfcmnxs9ls6qsrqxkvx0njrk913rjwl6d";
        "linux-x86_64" = "sha256:0x0dl4dsanyabmxdvjid4zmd1ba0xzi7gs0n69qy0giwfr6h43vi";
      };
    };
    "0.11.0" = {
      llvmPackages = llvmPackages_16;
      hash = "sha256-iuU1fzkbJxI+0N1PiLQM013Pd1bzrgqkbIyTxo5gB2I=";
      bootstrapHashes = {
        "linux-aarch64" = "sha256:0yjz3ddyl6xwpbnav964zva99z44r5h8s70n4mbwx4yil5rcs93q";
        "linux-x86_64" = "sha256:0385m6sfaxcfy91l4iwi3zkr705zbn4basvkkkbba7yh635aqr78";
      };
    };
    "0.12.1" = {
      llvmPackages = llvmPackages_17;
      hash = "sha256-C56jyVf16Co/XCloMLSRsbG9r/gBc8mzCdeEMHV2T2s=";
      bootstrapHashes = {
        "linux-aarch64" = "sha256:1p21g0py4b2x7iq18s2az6ql6ggafhwvz7xz1vwg85nbn5af6v5q";
        "linux-x86_64" = "sha256:0jixd5ac32r29avah5xazixrnc9sj80j05vg8idvz8x4z07c4l8v";
      };
    };
    "0.13.0" = {
      llvmPackages = llvmPackages_18;
      hash = "sha256-5qSiTq+UWGOwjDVZMIrAt2cDKHkyNPBSAEjpRQUByFM=";
      bootstrapHashes = {
        "linux-aarch64" = "sha256:0n55hsk537h20g8hd1hmrhghsvqpihxv7pzybyyk8vz6kksms95h";
        "linux-x86_64" = "sha256:01cvjk26ipz54q7dpp4669akh11aimw5zjq1chx3fh63aq2b02s2";
      };
    };
  } // zigVersions;

  mkPackage =
    {
      version,
      hash,
      llvmPackages,
      bootstrapHashes,
      patches ? [ ],
    }@args:
    {
      generic = darwin.apple_sdk_11_0.callPackage ./generic.nix (removeAttrs args [ "bootstrapHashes" ]);
      bootstrap = callPackage ./bootstrap.nix (
        removeAttrs args [
          "patches"
          "llvmPackages"
          "hash"
        ]
      );
    }
    ."${if isBootstrap then "bootstrap" else "generic"}";

  zigPackages = lib.mapAttrs' (
    version: args:
    lib.nameValuePair (lib.versions.majorMinor version) (mkPackage (args // { inherit version; }))
  ) versions;
in
zigPackages
