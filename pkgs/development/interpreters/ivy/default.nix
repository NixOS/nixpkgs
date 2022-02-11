{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ivy";
  version = "0.1.13";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "robpike";
    repo = "ivy";
    sha256 = "sha256-IiQrmmHitKUItm/ZSTQ3jGO3ls8vPPexyOtUvfq3yeU=";
  };

  vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

  subPackages = [ "." ];

  meta = with lib; {
    homepage = "https://github.com/robpike/ivy";
    description = "ivy, an APL-like calculator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ smasher164 ];
  };
}
