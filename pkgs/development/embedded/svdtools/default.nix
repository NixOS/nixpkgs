{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.3.1";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-oj09Huy38Nf7L6SSM5CIq2rzATrFB5FcTntXqB2dZHE=";
  };

  cargoHash = "sha256-lZk8QChDLfhv3iB0INGKgS5tM/ETdpdUpbq6egPS1uI=";

  meta = with lib; {
    description = "Tools to handle vendor-supplied, often buggy SVD files";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG-rust.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
