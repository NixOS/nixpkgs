{ lib, fetchFromGitHub, makeRustPlatform, rustc, cargo }:

let
  args = rec {
    pname = "cargo-auditable";
    version = "0.6.0";

    src = fetchFromGitHub {
      owner = "rust-secure-code";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-mSiEC+9QtRjWmywJnGgUqp+q8fhY0qUYrgjrAVaY114=";
    };

    cargoSha256 = "sha256-Wz5My/QxPpZVsPBUe3KHT3ttD6CTU8NCY8rhFEC+UlA=";

    meta = with lib; {
      description = "A tool to make production Rust binaries auditable";
      homepage = "https://github.com/rust-secure-code/cargo-auditable";
      changelog = "https://github.com/rust-secure-code/cargo-auditable/blob/v${version}/cargo-auditable/CHANGELOG.md";
      license = with licenses; [ mit /* or */ asl20 ];
      maintainers = with maintainers; [ figsoda ];
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
  auditable = true; # TODO: remove when this is the default
})
