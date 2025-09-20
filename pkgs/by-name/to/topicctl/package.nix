{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "topicctl";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "topicctl";
    rev = "v${version}";
    sha256 = "sha256-+Khy7WL57oHCb1a4HIJPq9UdMuYXlkf8/GikoRvUT1Y=";
  };

  vendorHash = "sha256-M/lNhGD9zNmwkzTAjp0lbAeliNpLOCVJbOG16N76QL4=";

  ldflags = [
    "-X main.BuildVersion=${version}"
    "-X main.BuildCommitSha=unknown"
    "-X main.BuildDate=unknown"
  ];

  # needs a kafka server
  doCheck = false;

  meta = with lib; {
    description = "Tool for easy, declarative management of Kafka topics";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [
      eskytthe
      srhb
    ];
    mainProgram = "topicctl";
  };
}
