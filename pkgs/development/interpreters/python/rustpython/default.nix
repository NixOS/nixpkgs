{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, SystemConfiguration
, python3
}:

rustPlatform.buildRustPackage rec {
  pname = "rustpython";
  version = "unstable-2022-10-11";

  src = fetchFromGitHub {
    owner = "RustPython";
    repo = "RustPython";
    rev = "273ffd969ca6536df06d9f69076c2badb86f8f8c";
    sha256 = "sha256-t/3++EeP7a8t2H0IEPLogBri7+6u+2+v+lNb4/Ty1/w=";
  };

  cargoHash = "sha256-Pv7SK64+eoK1VUxDh1oH0g1veWoIvBhiZE9JI/alXJ4=";

  # freeze the stdlib into the rustpython binary
  cargoBuildFlags = [ "--features=freeze-stdlib" ];

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
