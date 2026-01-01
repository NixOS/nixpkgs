{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "urlhunter";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "utkusen";
    repo = "urlhunter";
    rev = "v${version}";
    sha256 = "sha256-QRQLN8NFIIvlK+sHNj0MMs7tlBODMKHdWJFh/LwnysI=";
  };

  vendorHash = "sha256-tlFCovCzqgaLcxcGmWXLYUjaAvFG0o11ei8uMzWJs6Q=";

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Recon tool that allows searching shortened URLs";
    mainProgram = "urlhunter";
    longDescription = ''
      urlhunter is a recon tool that allows searching on URLs that are
      exposed via shortener services such as bit.ly and goo.gl.
    '';
    homepage = "https://github.com/utkusen/urlhunter";
<<<<<<< HEAD
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
