{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.3.17";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-mXxxsAN/KgQOAgVq6jNVtrb11g3WUbU6e+T1Tgmgciw=";
  };

  cargoHash = "sha256-2qA9xMJFj+28/ZCnz4KKm7T3EiG6NUY01JQvYmmuIOc=";

  meta = with lib; {
    description = "Tools to handle vendor-supplied, often buggy SVD files";
    mainProgram = "svdtools";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG-rust.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
