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

<<<<<<< HEAD
  meta = {
    description = "Dump ACME data from traefik to certificates";
    homepage = "https://github.com/ldez/traefik-certs-dumper";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nickcao ];
=======
  meta = with lib; {
    description = "Dump ACME data from traefik to certificates";
    homepage = "https://github.com/ldez/traefik-certs-dumper";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "traefik-certs-dumper";
  };
}
