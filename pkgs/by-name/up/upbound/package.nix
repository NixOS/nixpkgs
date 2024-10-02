{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "upbound";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "up";
    rev = "v${version}";
    hash = "sha256-PJMOR/XpWqtSIb3x61o0iLwETCHA5e07etmEZYQtzXw=";
  };

  vendorHash = "sha256-WLRXj4G49JEbQc2aFAjLLCpQrDhN94jazWxfM70hHqs=";

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
