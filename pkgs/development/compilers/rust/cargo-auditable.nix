{ lib, buildPackages, fetchFromGitHub, fetchpatch, makeRustPlatform, installShellFiles, stdenv }:

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

    patches = [
      (fetchpatch {
        name = "rust-1.77-tests.patch";
        url = "https://github.com/rust-secure-code/cargo-auditable/commit/5317a27244fc428335c4e7a1d066ae0f65f0d496.patch";
        hash = "sha256-UblGseiSC/2eE4rcnTgYzxAMrutHFSdxKTHqKj1mX5o=";
      })
    ];

    cargoHash = "sha256-4o3ctun/8VcBRuj+j0Yaawdkyn6Z6LPp+FTyhPxQWU8=";

    meta = with lib; {
      description = "Tool to make production Rust binaries auditable";
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
