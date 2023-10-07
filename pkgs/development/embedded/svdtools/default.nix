{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.3.3";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-pZufVz7m91MiD1TfzTzS6mL0eBxawcr43GAfvDJVqfU=";
  };

  cargoHash = "sha256-FAJZ/3eNhxPvIKXnE9lpejQuMi+yeBaA5ra9Peb2yIM=";

  meta = with lib; {
    description = "Tools to handle vendor-supplied, often buggy SVD files";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG-rust.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
