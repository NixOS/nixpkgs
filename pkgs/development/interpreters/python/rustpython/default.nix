{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, SystemConfiguration
, python3
, fetchpatch
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

  patches = [
    # Patched needed because this version does not build with recent versions of Rust.
    # See: https://github.com/RustPython/RustPython/issues/3614
    (fetchpatch {
      url = "https://github.com/RustPython/RustPython/commit/61f7d241c0d7acca626a8e932b71e8ac5871362d.patch";
      hash = "sha256-+2xlu+/etzCxkP/6Z1n+FwsAM6m+uPCriOoYuEI1j1U=";
    })
  ];

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
  };
}
