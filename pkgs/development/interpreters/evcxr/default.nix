{ callPackage
, lib
, makeWrapper
, runCommand

, CoreServices
, Security

, cargo
, rustPlatform
, rustc
}:

let
  evcxr = callPackage ./evcxr.nix {
    inherit CoreServices Security;
  };

  withPackages = callPackage ./withPackages.nix {
    inherit cargo rustPlatform;
  };

  cargoHome = packageNames: runCommand "cargo-home" {} ''
    mkdir -p $out
    cp "${withPackages.cargoNix packageNames}"/Cargo.toml $out
    cp "${withPackages.cargoNix packageNames}"/Cargo.lock $out

    mkdir -p $out/src
    touch $out/src/lib.rs

    cat <<EOT >> $out/config.toml
    [source.crates-io]
    replace-with = "vendored-sources"

    [source.vendored-sources]
    directory = "${withPackages.vendorDependencies packageNames}"

    [net]
    offline = true
    EOT
  '';

in

evcxr.overrideAttrs (oldAttrs: {
  passthru = (oldAttrs.passthru or {}) // {
    withPackages = packageNames:
      runCommand "evcxr" {
        buildInputs = [makeWrapper];

        makeWrapperArgs = [
          "--set" "EVCXR_CONFIG_DIR" "${withPackages.evcxrConfigDir packageNames}"
          "--set" "CARGO_HOME" "${cargoHome packageNames}"
          "--prefix" "PATH" ":" "${lib.makeBinPath [rustc cargo]}"
        ];

        passthru = {
          cargoHome = cargoHome packageNames;
        };
      } ''
        mkdir -p $out/bin
        makeWrapper ${evcxr}/bin/evcxr $out/bin/evcxr $makeWrapperArgs
        makeWrapper ${evcxr}/bin/evcxr_jupyter $out/bin/evcxr_jupyter $makeWrapperArgs
      '';
  };
})
