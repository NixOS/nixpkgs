{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tun2socks";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "xjasonlyu";
    repo = "tun2socks";
    tag = "v${version}";
    hash = "sha256-ec4M107BE6MCnW/uz9S83JYJtY9tsQQXDFL98h951DA=";
  };

  vendorHash = "sha256-YAAdyV2p/Ci9RzgVWYXBwR/ctERSQ8SPK7AbwRuUJiI=";

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
