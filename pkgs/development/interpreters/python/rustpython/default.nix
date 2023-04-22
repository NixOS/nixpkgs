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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "RustPython";
    repo = "RustPython";
    rev = "v${version}";
    hash = "sha256-RNUOBBbq4ca9yEKNj5TZTOQW0hruWOIm/G+YCHoJ19U=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rustpython-doc-0.1.0" = "sha256-4xBiV1FcYA05cWs9fQV+OklZEU1VZunhCo9deOSWPe8=";
    };
  };

  patches = [
    # Fix aarch64 compatibility for sqlite. Remove with the next release. https://github.com/RustPython/RustPython/pull/4499
    (fetchpatch {
      url = "https://github.com/RustPython/RustPython/commit/9cac89347e2276fcb309f108561e99f4be5baff2.patch";
      hash = "sha256-vUPQI/5ec6/36Vdtt7/B2unPDsVrGh5iEiSMBRatxWU=";
    })
  ];

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
