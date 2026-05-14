{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "traefik-certs-dumper";
  version = "2.11.2";

  src = fetchFromGitHub {
    owner = "ldez";
    repo = "traefik-certs-dumper";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-4s4IN/aDGP/9mFEf3Sl8/R9GtQlYSSXjxPrSA2CYuWE=";
  };

  vendorHash = "sha256-VKtYOc1PbR0UZ9mJZ5houzVEPN+j+OnTw42eFr1aQgg=";
  excludedPackages = "integrationtest";

  meta = {
    description = "Dump ACME data from traefik to certificates";
    homepage = "https://github.com/ldez/traefik-certs-dumper";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nickcao ];
    mainProgram = "traefik-certs-dumper";
  };
})
