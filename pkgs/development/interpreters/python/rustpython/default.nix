{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, SystemConfiguration
, python3
}:

rustPlatform.buildRustPackage rec {
  pname = "rustpython";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "RustPython";
    repo = "RustPython";
    rev = "v${version}";
    hash = "sha256-RNUOBBbq4ca9yEKNj5TZTOQW0hruWOIm/G+YCHoJ19U=";
  };

  cargoHash = "sha256-PYSsv/dZ3dxferTDbRLF9T8GGj9kZ3ixWNglQKtA3pE=";

  # freeze the stdlib into the rustpython binary
  cargoBuildFlags = [ "--features=freeze-stdlib" ];

  buildInputs = lib.optionals stdenv.isDarwin [ SystemConfiguration ];

  nativeCheckInputs = [ python3 ];

  meta = with lib; {
    description = "Python 3 interpreter in written Rust";
    homepage = "https://rustpython.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
