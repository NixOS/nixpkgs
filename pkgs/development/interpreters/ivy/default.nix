{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ivy";
  version = "0.2.10";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "robpike";
    repo = "ivy";
    hash = "sha256-6rZfBx6jKNOEnG+cmrzgvjUoCHQe+olPeX11qX8ep38=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/robpike/ivy";
    description = "ivy, an APL-like calculator";
    mainProgram = "ivy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ smasher164 ];
  };
}
