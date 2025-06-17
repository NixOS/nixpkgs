{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "tempo";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "tempo";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-rloHxcGrgVhBGIKg29wzhPfa3NQ8pI8aISiVi2M/BJ4=";
  };

  vendorHash = null;

  subPackages = [
    "cmd/tempo-cli"
    "cmd/tempo-query"
    "cmd/tempo-vulture"
    "cmd/tempo"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
    "-X=main.Branch=<release>"
    "-X=main.Revision=${version}"
  ];

  # tests use docker
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "High volume, minimal dependency trace storage";
    license = licenses.asl20;
    homepage = "https://grafana.com/oss/tempo/";
    maintainers = [ ];
  };
}
