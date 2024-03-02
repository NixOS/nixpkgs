{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.3.10";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-VEGLUc8ThhD/R+K2IFGvE800euz8oF0kuekGO627rvU=";
  };

  cargoHash = "sha256-T0yTGCDgRQUySUHNkoB4kqoKS/0kJWDi04ysPGO79HY=";

  meta = with lib; {
    description = "Tools to handle vendor-supplied, often buggy SVD files";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG-rust.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
