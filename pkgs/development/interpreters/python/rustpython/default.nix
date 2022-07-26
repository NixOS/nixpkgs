{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, SystemConfiguration
, python3
}:

rustPlatform.buildRustPackage rec {
  pname = "rustpython";
  version = "unstable-2021-12-09";

  src = fetchFromGitHub {
    owner = "RustPython";
    repo = "RustPython";
    rev = "db3b3127df34ff5dd569301aa36ed71ae5624e4e";
    sha256 = "sha256-YwGfXs3A5L/18mHnnWubPU3Y8EI9uU3keJ2HJnnTwv0=";
  };

  cargoHash = "sha256-T85kiPG80oZ4mwpb8Ag40wDHKx2Aens+gM7NGXan5lM=";

  # freeze the stdlib into the rustpython binary
  cargoBuildFlags = "--features=freeze-stdlib";

  buildInputs = lib.optionals stdenv.isDarwin [ SystemConfiguration ];

  checkInputs = [ python3 ];

  meta = with lib; {
    description = "Python 3 interpreter in written Rust";
    homepage = "https://rustpython.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];

    # TODO: Remove once nixpkgs uses newer SDKs that supports '*at' functions.
    # Probably macOS SDK 10.13 or later. Check the current version in
    # .../os-specific/darwin/apple-sdk/default.nix
    #
    # From the build logs:
    #
    # > Undefined symbols for architecture x86_64: "_utimensat"
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
