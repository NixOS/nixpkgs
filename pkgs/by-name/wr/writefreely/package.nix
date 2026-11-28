{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "writefreely";
  version = "0.17.3";

  src = fetchFromGitHub {
    owner = "writefreely";
    repo = "writefreely";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-XeLpPe5RKyMAzfl5JV6J1VzNXivXFM/Gd3HoFPNcyvQ=";
  };

  vendorHash = "sha256-KQRd5KvtBIqsvtBC5i2Rje4fVPu1ZsHLkH736H5WTPE=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/writefreely/writefreely.softwareVer=${finalAttrs.version}"
  ];

  tags = [ "sqlite" ];

  subPackages = [ "cmd/writefreely" ];

  passthru.tests = {
    inherit (nixosTests) writefreely;
  };

  meta = {
    description = "Build a digital writing community";
    homepage = "https://github.com/writefreely/writefreely";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ soopyc ];
    mainProgram = "writefreely";
  };
})
