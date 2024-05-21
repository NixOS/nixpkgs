{ lib
, rustPlatform
, fetchCrate
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "hvm";
  version = "2.0.12";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-/55SK/5zBKXmucRQPoYt/8IHxisQlOxNEVMAZVMtCNI=";
  };

  cargoHash = "sha256-9U8Y0KaQHIfOZnCKbl94VvjS/7Qmi6UnKMDZDTXcye0=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.IOKit
  ];

  # enable nightly features
  RUSTC_BOOTSTRAP = true;

  meta = with lib; {
    description = "A pure functional compile target that is lazy, non-garbage-collected, and parallel";
    mainProgram = "hvm";
    homepage = "https://github.com/higherorderco/hvm";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
