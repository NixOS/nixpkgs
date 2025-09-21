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
    version = "0.7.0";

    src = fetchFromGitHub {
      owner = "rust-secure-code";
      repo = "cargo-auditable";
      tag = "v${version}";
      hash = "sha256-hFdG3LEPhk1UqlmWwFaHs9d2xyl6edb4WfOYgcE9/8I=";
    };

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit pname version src;
      hash = "sha256-2dAlo+5rwzU2DxsbjBfri/lF6NFIvNeY7gx8we/5aQs=";
    };

    checkFlags = [
      # requires wasm32-unknown-unknown target
      "--skip=test_wasm"
      # these tests are panicking with the following error:
      # "Build with `cargo auditable` failed"
      "--skip=test_proc_macro"
      "--skip=test_self_hosting"
    ];

    meta = with lib; {
      description = "Tool to make production Rust binaries auditable";
      mainProgram = "cargo-auditable";
      homepage = "https://github.com/rust-secure-code/cargo-auditable";
      changelog = "https://github.com/rust-secure-code/cargo-auditable/blob/v${version}/cargo-auditable/CHANGELOG.md";
      license = with licenses; [
        mit # or
        asl20
      ];
      maintainers = with maintainers; [ figsoda ];
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
