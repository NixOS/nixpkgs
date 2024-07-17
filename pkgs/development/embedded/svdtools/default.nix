{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.3.14";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-sTogOCpcfJHy+e3T4pEvclCddCUX+RHCQ238oz5bAEo=";
  };

  cargoHash = "sha256-lRSt46yxFWSlhU6Pns3PCLJ4c6Fvi4EbOIqVx9IoPCc=";

  meta = with lib; {
    description = "Tools to handle vendor-supplied, often buggy SVD files";
    mainProgram = "svdtools";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG-rust.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ newam ];
  };
}
