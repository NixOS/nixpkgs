{ lib
, rustPlatform
, fetchCrate
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "hvm";
  version = "1.0.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-nPkUGUcekZ2fvQgiVTNvt8vfQsNMyqsrkT2zqEfu/bE=";
  };

  cargoSha256 = "sha256-EaZTpKFZPfDlP/2XylhJHznvlah7VNw4snrKDmT7ecw=";

  buildInputs = lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    darwin.apple_sdk.frameworks.IOKit
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    darwin.apple_sdk_11_0.frameworks.Foundation
  ];

  # tests are broken
  doCheck = false;

  # enable nightly features
  RUSTC_BOOTSTRAP = true;

  meta = with lib; {
    description = "A pure functional compile target that is lazy, non-garbage-collected, and parallel";
    homepage = "https://github.com/kindelia/hvm";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
