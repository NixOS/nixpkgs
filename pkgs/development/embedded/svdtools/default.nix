{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.2.8";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-x0C+1Ld4RImmS6x9l9jQaZ/sEd3iLFmmwOWNfA+xYsk=";
  };

  cargoSha256 = "sha256-U1YiQdfk/SgRicAND0X8KdHKgX7wHnYspWNF270WDrE=";

  meta = with lib; {
    description = "Tools to handle vendor-supplied, often buggy SVD files";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG-rust.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
