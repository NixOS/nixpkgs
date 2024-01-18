{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.3.8";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-daATz1bd5fwfYnfVbweJd/I6SsQyg2CC+MEZ5WLyZBw=";
  };

  cargoHash = "sha256-TSLUBkPRab6cwlXJw8tHpqYjhLtVa+QJZq13Qj/0UzU=";

  meta = with lib; {
    description = "Tools to handle vendor-supplied, often buggy SVD files";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG-rust.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
