{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.2.5";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-tN1GC4tQXyaA8bgq7wB/NZEdO14p/0f8BXtgTk6aOzg=";
  };

  cargoSha256 = "sha256-puaveP9a11rlGgsguCfueYXfYSd7Xew8ZRGeDP8WrSI=";

  meta = with lib; {
    description = "Tools to handle vendor-supplied, often buggy SVD files";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG-rust.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
