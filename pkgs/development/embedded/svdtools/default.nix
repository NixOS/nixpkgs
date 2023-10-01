{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.3.2";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-gp2AN68X7UpTHlySA84jYc/qTnUvNDRo4Qptj4oZfj8=";
  };

  cargoHash = "sha256-7d2LuouhPfSi/h7si3IFCHRuRvsTNArK5L0JSewCfUQ=";

  meta = with lib; {
    description = "Tools to handle vendor-supplied, often buggy SVD files";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG-rust.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
