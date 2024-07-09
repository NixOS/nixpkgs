{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.3.15";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-P4XwIJnXnIQcp/l8GR7Mx8ybn1GdtiXVpQcky1JYVuU=";
  };

  cargoHash = "sha256-dBqbZWVTrIj2ji7JmLnlglvt4GkKef48kcl/V54thaQ=";

  meta = with lib; {
    description = "Tools to handle vendor-supplied, often buggy SVD files";
    mainProgram = "svdtools";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG-rust.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
