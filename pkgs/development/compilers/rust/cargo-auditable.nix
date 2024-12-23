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
    version = "0.6.5";

    src = fetchFromGitHub {
      owner = "rust-secure-code";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-zjv2/qZM0vRyz45DeKRtPHaamv2iLtjpSedVTEXeDr8=";
    };

    cargoHash = "sha256-uNoqWT3gVslGEPcyrfFeOquvSlLzZbPO4yM1YJeD8N4=";

    checkFlags = [
      # requires wasm32-unknown-unknown target
      "--skip=test_wasm"
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
