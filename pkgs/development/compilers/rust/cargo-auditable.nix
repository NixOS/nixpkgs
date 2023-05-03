{ lib, fetchFromGitHub, makeRustPlatform, rustc, cargo, installShellFiles, stdenv }:

let
  args = rec {
    pname = "cargo-auditable";
    version = "0.6.1";

    src = fetchFromGitHub {
      owner = "rust-secure-code";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-MKMPLv8jeST0l4tq+MMPC18qfZMmBixdj6Ng19YKepU=";
    };

    cargoSha256 = "sha256-6/f7pNaTL+U6bI6jMakU/lfwYYxN/EM3WkKZcydsyLk=";

    # Cargo.lock is outdated
    preConfigure = ''
      cargo update --offline
    '';

    meta = with lib; {
      description = "A tool to make production Rust binaries auditable";
      homepage = "https://github.com/rust-secure-code/cargo-auditable";
      changelog = "https://github.com/rust-secure-code/cargo-auditable/blob/v${version}/cargo-auditable/CHANGELOG.md";
      license = with licenses; [ mit /* or */ asl20 ];
      maintainers = with maintainers; [ figsoda ];
      broken = stdenv.hostPlatform != stdenv.buildPlatform;
    };
  };

  rustPlatform = makeRustPlatform {
    inherit rustc;
    cargo = cargo.override {
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
