{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.3.0";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-B+G2HIGbuKeiys3bLR2U+P40TD8YpqzAb4oENNb8gYg=";
  };

  cargoHash = "sha256-W6/LZE98V1teiv9Wp9tsIqlY18MoMiNZ+fqTJ567xrg=";

  meta = with lib; {
    description = "Tools to handle vendor-supplied, often buggy SVD files";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG-rust.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
