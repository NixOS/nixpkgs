{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "writefreely";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "writefreely";
    repo = "writefreely";
    rev = "v${version}";
    sha256 = "sha256-VM5TkQAohxGmtbQs9ZWxCqF4kJ/9wtihz+p1twd+W9E=";
  };

  vendorHash = "sha256-5X+EYV1RFbzB26gi7IYcNpWtNlkTaK2SnDxYJL1AlaA=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/writefreely/writefreely.softwareVer=${version}"
  ];

  tags = [ "sqlite" ];

  subPackages = [ "cmd/writefreely" ];

  passthru.tests = {
    inherit (nixosTests) writefreely;
  };

  meta = with lib; {
    description = "Build a digital writing community";
    homepage = "https://github.com/writefreely/writefreely";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ soopyc ];
    mainProgram = "writefreely";
  };
}
