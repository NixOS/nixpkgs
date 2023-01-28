{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "svdtools";
  version = "0.2.7";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-pRY9lL04BcZDYeFcdArIp2PcWiCZBurCYpYtYhPqFsg=";
  };

  cargoSha256 = "sha256-9XymDE9ON11VfZObrMiARmpJay2g2mKEf0l2eojbjL8=";

  meta = with lib; {
    description = "Tools to handle vendor-supplied, often buggy SVD files";
    homepage = "https://github.com/stm32-rs/svdtools";
    changelog = "https://github.com/stm32-rs/svdtools/blob/v${version}/CHANGELOG-rust.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
