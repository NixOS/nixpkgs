{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tun2socks";
  version = "2.5.2-unstable-2024-02-28";

  src = fetchFromGitHub {
    owner = "xjasonlyu";
    repo = pname;
    rev = "8c7c9085c21d8be8d18bf79ff547e1f2225842a9";
    hash = "sha256-LdiCVp6w5yGbFnbArUcjPIwbqFk3zgbbZO1rQNW4w0M=";
  };

  vendorHash = "sha256-7x3vVRFFxWhwwelPJ2EV78UTSXIo6bMj3ljVIPTPteg=";

  ldflags = [
    "-w"
    "-s"
    "-X github.com/xjasonlyu/tun2socks/v2/internal/version.Version=v${version}"
    "-X github.com/xjasonlyu/tun2socks/v2/internal/version.GitCommit=v${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/xjasonlyu/tun2socks";
    description = "tun2socks - powered by gVisor TCP/IP stack";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "tun2socks";
  };
}
