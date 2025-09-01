{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:

buildGoModule rec {
  pname = "traefik-certs-dumper";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "ldez";
    repo = "traefik-certs-dumper";
    rev = "v${version}";
    sha256 = "sha256-zXbtabh5ZziELZHzvYisXETPUmhHAVo6sMuF4O3crBY=";
  };

  vendorHash = "sha256-WpYxI+7qBYibojPtYlWmDrmJYlRlVwTaqCMI5Vzh1RI=";
  excludedPackages = "integrationtest";

  meta = with lib; {
    description = "Dump ACME data from traefik to certificates";
    homepage = "https://github.com/ldez/traefik-certs-dumper";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "traefik-certs-dumper";
  };
}
