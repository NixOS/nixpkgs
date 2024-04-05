{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.3.11";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-LmpYsG/2oEdbAK2ePI+LYbGrVN+wC9gQS6GXNcF8XFg=";
  };

  cargoHash = "sha256-qsCa+YWE9dghG8T53TSDikWh+JhQt9v7A1Gn+/t5YZs=";

  meta = with lib; {
    description = "Tools to handle vendor-supplied, often buggy SVD files";
    mainProgram = "svdtools";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG-rust.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
