{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "writefreely";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "writefreely";
    repo = "writefreely";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-CzIlXy1StXuK8fY3+uZd2pu5hB/MWdJrN+WEdEZEzfk=";
  };

  vendorHash = "sha256-RrwcY2DNO90cG8YtTQ0nAkUMNnehd1JByHCw/QtGRNs=";

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
