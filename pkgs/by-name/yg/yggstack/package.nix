{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "yggstack";
  version = "0-unstable-2024-07-26";

  src = fetchFromGitHub {
    owner = "yggdrasil-network";
    repo = "yggstack";
    rev = "5a87e43f9a7a0efdb20c9bc9a2e342c335a8767b";
    sha256 = "sha256-1/Tr4LYXO+GIDzVAjFmPPsXD6X9ZKs1lFpLy4K4zeMw=";
  };

  vendorHash = "sha256-Sw9FCeZ6kIaEuxJ71XnxbbTdknBomxFuEeEyCSXeJcM=";

  ldflags = [
    "-X github.com/yggdrasil-network/yggdrasil-go/src/version.buildVersion=${version}"
    "-X github.com/yggdrasil-network/yggdrasil-go/src/version.buildName=${pname}"
    "-X github.com/yggdrasil-network/yggdrasil-go/src/config.defaultAdminListen=unix:///var/run/yggdrasil/yggdrasil.sock"
    "-s"
    "-w"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Yggdrasil as SOCKS proxy / port forwarder";
    homepage = "https://yggdrasil-network.github.io/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ehmry ];
  };
}
