{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "yggstack";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "yggdrasil-network";
    repo = "yggstack";
    rev = "${version}";
    hash = "sha256-RQ7AvVv+VLfgzlb7orZbSB7TNz/hj2fo832ed4WUN80=";
  };

  vendorHash = "sha256-Hjb3KSh+2qYYKdgv4+dsSp0kAbzz8gu9qnQdA7wB5fA=";

  ldflags = [
    "-X github.com/yggdrasil-network/yggdrasil-go/src/version.buildVersion=${version}"
    "-X github.com/yggdrasil-network/yggdrasil-go/src/version.buildName=yggstack"
    "-s"
    "-w"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Yggdrasil as SOCKS proxy / port forwarder";
    homepage = "https://yggdrasil-network.github.io/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ehmry peigongdsd ];
  };
}
