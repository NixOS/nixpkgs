{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.3.9";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-agIr2jM0BqLSXod5V+p//bxcnrXe2+wW5RMq8GAAwnI=";
  };

  cargoHash = "sha256-z9GmFjABgvh2xf4nujnZUgHvKvChfP4Guox89PuuxV8=";

  meta = with lib; {
    description = "Tools to handle vendor-supplied, often buggy SVD files";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG-rust.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
