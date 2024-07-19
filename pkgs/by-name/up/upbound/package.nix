{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "upbound";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "up";
    rev = "v${version}";
    sha256 = "sha256-nXP97J0DdcXPAD/gB3py5UXhe48Kaec7CRTHmalo+RQ=";
  };

  vendorHash = "sha256-9HnKpofJPxCieG5thNcLC7diA51ohzy7xgtniL7FEgo=";

  subPackages = [ "cmd/docker-credential-up" "cmd/up" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/upbound/up/internal/version.version=v${version}"
  ];

  meta = with lib; {
    description =
      "CLI for interacting with Upbound Cloud, Upbound Enterprise, and Universal Crossplane (UXP)";
    homepage = "https://upbound.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
    mainProgram = "up";
  };
}
