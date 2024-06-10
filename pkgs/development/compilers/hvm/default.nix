{ lib
, rustPlatform
, fetchCrate
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "hvm";
  version = "2.0.17";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-UzPEupmUnph7SjCc/T4sBSGXj8yLVdQlw+X9iM16zD8=";
  };

  cargoHash = "sha256-AchVbf+mn4qQtzWu84Dqek+btCm6BA9mcY+8iHWqdiw=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.IOKit
  ];

  meta = with lib; {
    description = "Massively parallel, optimal functional runtime in Rust";
    mainProgram = "hvm";
    homepage = "https://github.com/higherorderco/hvm";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
