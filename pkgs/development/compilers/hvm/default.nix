{ lib
, rustPlatform
, fetchCrate
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "hvm";
  version = "1.0.9";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-dO0GzbMopX84AKOtJYYW6vojcs4kYcZ8LQ4tXEgUN7I=";
  };

  cargoHash = "sha256-RQnyVRHWrqnKcI3Jy593jDTydG1nGyrScsqSNyJTDJk=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.IOKit
  ];

  # tests are broken
  doCheck = false;

  # enable nightly features
  RUSTC_BOOTSTRAP = true;

  meta = with lib; {
    description = "A pure functional compile target that is lazy, non-garbage-collected, and parallel";
    homepage = "https://github.com/higherorderco/hvm";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
