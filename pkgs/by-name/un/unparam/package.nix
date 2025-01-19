{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "unparam";
  version = "0-unstable-2024-05-28";

  src = fetchFromGitHub {
    owner = "mvdan";
    repo = "unparam";
    rev = "8a5130ca722ffad18c95cc467b561f1668b9b0d2";
    hash = "sha256-CYCXTriGUd4bNY6ZPfkX4puE1imcqYHnX1SXVdnXPGM=";
  };

  vendorHash = "sha256-2lNC4V1WQkJdkagIlBu6tj4SA4KJKstHXc+B4emKu6s=";

  subPackages = [ "." ];

  meta = {
    description = "Find unused parameters in Go";
    homepage = "https://github.com/mvdan/unparam";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "unparam";
  };
}
