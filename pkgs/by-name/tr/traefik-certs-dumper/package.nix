{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "traefik-certs-dumper";
  version = "2.11.3";

  src = fetchFromGitHub {
    owner = "ldez";
    repo = "traefik-certs-dumper";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-8x/3g2/6XVoR4EVR83aUDh16LSiG8r3buny+4F0qNH4=";
  };

  vendorHash = "sha256-DR1Bo4MwoJy7AZyuLsjkqbUHj12fN01mnyDVXcvmjMI=";
  excludedPackages = "integrationtest";

  meta = {
    description = "Dump ACME data from traefik to certificates";
    homepage = "https://github.com/ldez/traefik-certs-dumper";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nickcao ];
    mainProgram = "traefik-certs-dumper";
  };
})
