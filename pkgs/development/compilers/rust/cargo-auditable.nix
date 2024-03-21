{ lib, buildPackages, fetchFromGitHub, makeRustPlatform, installShellFiles, stdenv }:

let
  args = rec {
    pname = "cargo-auditable";
    version = "0.6.2";

    src = fetchFromGitHub {
      owner = "rust-secure-code";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-ERIzx9Fveanq7/aWcB2sviTxIahvSu0sTwgpGf/aYE8=";
    };

    cargoHash = "sha256-4o3ctun/8VcBRuj+j0Yaawdkyn6Z6LPp+FTyhPxQWU8=";

    # Cargo.lock is outdated
    preConfigure = ''
      cargo update --offline
    '';

    meta = with lib; {
      description = "A tool to make production Rust binaries auditable";
      mainProgram = "cargo-auditable";
      homepage = "https://github.com/rust-secure-code/cargo-auditable";
      changelog = "https://github.com/rust-secure-code/cargo-auditable/blob/v${version}/cargo-auditable/CHANGELOG.md";
      license = with licenses; [ mit /* or */ asl20 ];
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

  bootstrap = rustPlatform.buildRustPackage (args // {
    auditable = false;
  });
in

rustPlatform.buildRustPackage.override { cargo-auditable = bootstrap; } (args // {
  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage cargo-auditable/cargo-auditable.1
  '';

  passthru = {
    inherit bootstrap;
  };
})
