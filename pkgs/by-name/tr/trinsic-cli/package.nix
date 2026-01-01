{
  lib,
  rustPlatform,
  fetchurl,
}:

rustPlatform.buildRustPackage rec {
  pname = "trinsic-cli";
  version = "1.14.0";

  src = fetchurl {
    url = "https://github.com/trinsic-id/sdk/releases/download/v${version}/trinsic-cli-vendor-${version}.tar.gz";
    sha256 = "sha256-lPw55QcGMvY2YRYJGq4WC0fPbKiika4NF55tlb+i6So=";
  };

  cargoVendorDir = "vendor";
  doCheck = false;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Trinsic CLI";
    longDescription = ''
      Command line interface for Trinsic Ecosystems
    '';
    homepage = "https://trinsic.id/";
<<<<<<< HEAD
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tmarkovski ];
=======
    license = licenses.asl20;
    maintainers = with maintainers; [ tmarkovski ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "trinsic";
  };
}
