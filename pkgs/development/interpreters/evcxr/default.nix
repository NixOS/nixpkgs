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
    mkdir -p $out/index_base
    ln -s ${withPackages.cratesIndex} $out/index_base/index

    mkdir -p $out

    cp "${withPackages.cargoNix packageNames}"/Cargo.toml $out
    cp "${withPackages.cargoNix packageNames}"/Cargo.lock $out

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
      } ''
        mkdir -p $out/bin
        makeWrapper ${evcxr}/bin/evcxr $out/bin/evcxr $makeWrapperArgs
        makeWrapper ${evcxr}/bin/evcxr_jupyter $out/bin/evcxr_jupyter $makeWrapperArgs
      '';
  };
})
