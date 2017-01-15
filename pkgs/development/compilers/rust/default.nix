{ stdenv, fetchurl, callPackage, gdb, recurseIntoAttrs, makeRustPlatform, buildEnv,
  targets ? [], targetToolchains ? [], targetPatches ? [],
  makeWrapper}:

with stdenv.lib;
let
  sources = builtins.fromJSON (builtins.readFile ./sources.json);

  rustMaintainers = with maintainers;
    [ qknight madjar cstrahan wizeman globin havvy wkennington retrry ];

  rustcSrc = {
    channel,
    rustPlatform,
    forceBundledLLVM ? false,
    supportsVendoring ? true,
    targets ? [],
    targetPatches ? [],
    targetToolchains ? []
  } @ args:
  let
    metadata = sources.${channel}.rust-src.all;
  in callPackage ./rustc.nix {
    inherit (metadata) version;
    configureFlags = [ "--release-channel=${channel}" ];
    srcUrl = metadata.url;
    srcSha = metadata.sha256;

    patches = ["${./patches}${channel}/*.patch"]
      ++ (stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch);

    inherit rustPlatform targets targetPatches targetToolchains forceBundledLLVM supportsVendoring;
  };

  cargoSrc = { channel, rustc, rustPlatform, depsSha256 } @ args:
  let
    metadata = sources.${channel}.cargo-src.all;
  in callPackage ./cargo.nix rec {
    inherit (metadata) version;
    srcSha = metadata.sha256;
    srcRev = metadata.revision;

    inherit depsSha256;
    inherit rustc; # the rustc that will be wrapped by cargo
    inherit rustPlatform; # used to build cargo
  };

  rustcBin = channel: callPackage ./rustc-bin.nix {
    inherit sources channel;
  };

  cargoBin = channel: callPackage ./cargo-bin.nix {
    inherit sources channel;
  };

  # Rust wants cargo next to rustc.
  # Could be simplified when https://github.com/rust-lang/rust/issues/38950 is fixed
  bootstrapPlatform = rust: makeRustPlatform {
    rustc = stdenv.mkDerivation {
      name = "rust-cargo-bundle";
      src = null;
      phases = "installPhase";
      installPhase = ''
        mkdir -p $out/{bin,lib}
        cp -sR ${rust.rustc}/* $out/
        ln -s ${rust.cargo}/bin/cargo $out/bin/cargo
      '';
    };
    inherit (rust) cargo;
  };

  removeFailingDebugInfoTests = ''
    # Remove failing debuginfo tests because of old gdb version (<v8):
    # https://github.com/rust-lang/rust/issues/38948#issuecomment-271443596
    remove=(borrowed-enum.rs \
      generic-struct-style-enum.rs \
      generic-tuple-style-enum.rs \
      packed-struct.rs \
      recursive-struct.rs \
      struct-in-enum.rs \
      struct-style-enum.rs \
      tuple-style-enum.rs \
      union-smoke.rs \
      unique-enum.rs)
    for f in ''${remove[@]}; do
      rm -vr src/test/debuginfo/$f || true
    done
  '';
in rec {
  rustStableBin = {
    rustc = rustcBin "stable";
    cargo = cargoBin "stable";
  };

  rustStable = let
    platform = bootstrapPlatform rustStableBin;
  in {
    rustc = rustcSrc {
      channel = "stable";
      rustPlatform = platform;
      supportsVendoring = false;
    };

    cargo = cargoSrc {
      channel = "stable";
      rustPlatform = platform;
      rustc = rustStable.rustc;
      depsSha256 = "0ksiywli8r4lkprfknm0yz1w27060psi3db6wblqmi8sckzdm44h";
    };
  };

  rustBetaBin = {
    rustc = rustcBin "beta";
    cargo = cargoBin "beta";
  };

  rustBeta = let
    platform = bootstrapPlatform rustBetaBin;
  in {
    rustc = overrideDerivation (rustcSrc {
      channel = "beta";
      rustPlatform = platform;
      # TODO: figure out why linking fails without this
      forceBundledLLVM = true;
    }) (oldAttrs: {
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ gdb rustBetaBin.cargo ];
      postPatch = ''
        ${oldAttrs.postPatch}
        ${removeFailingDebugInfoTests}
      '';
    });

    cargo = cargoSrc {
      channel = "beta";
      rustPlatform = platform;
      rustc = rustBetaBin.rustc;
      depsSha256 = "11s2xpgfhl4mb4wa2nk4mzsypr7m9daxxc7l0vraiz5cr77gk7qq";
    };
  };

  rustNightlyBin = {
    rustc = rustcBin "nightly";
    cargo = cargoBin "nightly";
  };

  rustNightly = let
    platform = bootstrapPlatform rustNightlyBin;
  in {
    rustc = overrideDerivation (rustcSrc {
      channel = "nightly";
      rustPlatform = platform;
      forceBundledLLVM = true;
    }) (oldAttrs: {
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ gdb rustNightlyBin.cargo ];
      postPatch = ''
        ${oldAttrs.postPatch}
        ${removeFailingDebugInfoTests}
      '';
    });

    cargo = cargoSrc {
      channel = "nightly";
      rustPlatform = platform;
      rustc = rustNightlyBin.rustc;
      depsSha256 = "1sywnhzgambmqsjs2xlnzracfv7vjljha55hgf8wca2marafr5dp";
    };
  };
}
