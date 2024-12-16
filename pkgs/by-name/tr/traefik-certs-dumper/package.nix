{ fetchFromGitHub, buildGoModule, lib }:

buildGoModule rec {
  pname = "traefik-certs-dumper";
  version = "2.9.3";

  src = fetchFromGitHub {
    owner = "ldez";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-krJ2oPz72mqlmJxQTZaFbyDtUaprRLJGZMSS7ZuvPfA=";
  };

  vendorHash = "sha256-CmqeIQk7lAENMDNWAG7XylnXRXvgyRN5GMt0ilwJX0U=";
  excludedPackages = "integrationtest";

  meta = with lib; {
    description = "dump ACME data from traefik to certificates";
    homepage = "https://github.com/ldez/traefik-certs-dumper";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "traefik-certs-dumper";
  };
}
