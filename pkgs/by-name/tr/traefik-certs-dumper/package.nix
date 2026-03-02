{
  fetchFromGitHub,
  buildGoModule,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "traefik-certs-dumper";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "ldez";
    repo = "traefik-certs-dumper";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-rjD0zt5kJ7A4TLn3jQBLGvzvHthszP9AvmcILVo5lzk=";
  };

  vendorHash = "sha256-hGmcE8vEJI4nZOVFbDGWpnfTyupFydwGj09gMb2Mctc=";
  excludedPackages = "integrationtest";

  meta = {
    description = "Dump ACME data from traefik to certificates";
    homepage = "https://github.com/ldez/traefik-certs-dumper";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nickcao ];
    mainProgram = "traefik-certs-dumper";
  };
})
