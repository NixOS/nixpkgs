{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.3.4";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-rdBUEOyE4bHqPXZs3MxT/oivagKmJIVE/hI9mp0RY0k=";
  };

  cargoHash = "sha256-mPz8m/9VGKSqXan/R1k1JTZ9a44CwCL6JefVyeeREeE=";

  meta = with lib; {
    description = "Tools to handle vendor-supplied, often buggy SVD files";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG-rust.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
