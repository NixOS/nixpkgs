{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.2.6";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-y0RCUSk7YEE5bF/dVEuH/sTtHcVIT4+P0DVkPiNf54I=";
  };

  cargoSha256 = "sha256-PPoHTh8cjQMkD69BYk/HW/PwDV5j/OrHHpjFZdBqZxM=";

  meta = with lib; {
    description = "Tools to handle vendor-supplied, often buggy SVD files";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG-rust.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
