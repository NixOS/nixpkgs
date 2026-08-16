{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tun2socks";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "xjasonlyu";
    repo = "tun2socks";
    tag = "v${version}";
    hash = "sha256-eObTZsNy5sBzgM7YNsA6Q4IWazWv3MTywrLtkv7XLOc=";
  };

  vendorHash = "sha256-slsPN0XvE6/8CcAEhSwm743IGYNpIljq1DVTsjpY6lk=";

  ldflags = [
    "-w"
    "-s"
    "-X github.com/xjasonlyu/tun2socks/v2/internal/version.Version=v${version}"
    "-X github.com/xjasonlyu/tun2socks/v2/internal/version.GitCommit=v${version}"
  ];

  meta = {
    homepage = "https://github.com/xjasonlyu/tun2socks";
    description = "Routes network traffic from any application through a proxy";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ nickcao ];
    mainProgram = "tun2socks";
  };
}
