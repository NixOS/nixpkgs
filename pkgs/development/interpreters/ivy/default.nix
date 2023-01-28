{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ivy";
  version = "0.2.8";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "robpike";
    repo = "ivy";
    sha256 = "sha256-pb/dJfEXz13myT6XadCg0kKd+n9bcHNBc84ES+hDw2Y=";
  };

  vendorSha256 = null;

  subPackages = [ "." ];

  meta = with lib; {
    homepage = "https://github.com/robpike/ivy";
    description = "ivy, an APL-like calculator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ smasher164 ];
  };
}
