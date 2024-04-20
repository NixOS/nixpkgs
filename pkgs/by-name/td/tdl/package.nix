{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "tdl";
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "iyear";
    repo = "tdl";
    rev = "v${version}";
    hash = "sha256-YbyTUmYXcltmvJVatS1TLkqZli7sba4ARi9bRkcd07M=";
  };

  vendorHash = "sha256-WFhwmV4zlYDQA2Xow51m/AQ9GwUwr26rW3WMldduLl8=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/iyear/tdl/pkg/consts.Version=${version}"
  ];

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "A Telegram downloader/tools written in Golang";
    homepage = "https://github.com/iyear/tdl";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Ligthiago ];
    mainProgram = "tdl";
  };
}
