{
  lib,
  buildPackages,
  fetchFromGitHub,
  makeRustPlatform,
  installShellFiles,
  stdenv,
}:

let
  args = rec {
    pname = "cargo-auditable";
    version = "0.7.1";

    src = fetchFromGitHub {
      owner = "rust-secure-code";
      repo = "cargo-auditable";
      tag = "v${version}";
      hash = "sha256-t5il9CVhYZtmKrWxBoDpKZaGTPjpBO6Cotw0vuAthvc=";
    };

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit pname version src;
      hash = "sha256-2ZbRANFMExILSUrrft2fRWjScy0kMreyQMtHWA7iRds=";
    };

    checkFlags = [
      # requires wasm32-unknown-unknown target
      "--skip=test_wasm"
      # Fails starting from 0.6.6 due to rustc argument parsing changes
      # (pico-args eq-separator feature or --emit flag handling).
      "--skip=test_self_hosting"
      # Fails starting from 0.7.0 when the test runs with sbom=true.
      # The test sets CARGO_BUILD_SBOM=true which propagates to nested cargo builds.
      # Nested builds try to use `-Z sbom`, but stable Cargo doesn't support this flag.
      # (RUSTC_BOOTSTRAP=1 only affects rustc, not Cargo's -Z flags)
      "--skip=test_proc_macro"
    ];

    meta = {
      description = "Tool to make production Rust binaries auditable";
      mainProgram = "cargo-auditable";
      homepage = "https://github.com/rust-secure-code/cargo-auditable";
      changelog = "https://github.com/rust-secure-code/cargo-auditable/blob/v${version}/cargo-auditable/CHANGELOG.md";
      license = with lib.licenses; [
        mit # or
        asl20
      ];
      maintainers = with lib.maintainers; [ RossSmyth ];
      broken = stdenv.hostPlatform != stdenv.buildPlatform;
    };
  };

  rustPlatform = makeRustPlatform {
    inherit (buildPackages) rustc;
    cargo = buildPackages.cargo.override {
      auditable = false;
    };
  };

  bootstrap = rustPlatform.buildRustPackage (
    args
    // {
      auditable = false;
    }
  );
in

rustPlatform.buildRustPackage.override { cargo-auditable = bootstrap; } (
  args
  // {
    nativeBuildInputs = [
      installShellFiles
    ];

    postInstall = ''
      installManPage cargo-auditable/cargo-auditable.1
    '';

    passthru = {
      inherit bootstrap;
    };
  }
)
