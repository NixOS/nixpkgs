{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "brev-cli";
  version = "0.6.153";

  src = fetchFromGitHub {
    owner = "brevdev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-v9jkQoamLiH8LsBmqNwUrnAvXamMHxhJ94SXFgdt9Cc=";
  };

  vendorSha256 = "sha256-cNwfK1LpguRfM/ORebU6v+JLIxDJdT5y+zM3KmEamEw=";

  CGO_ENABLED = 0;
  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=${src.rev}"
  ];

  postInstall = ''
    mv $out/bin/brev-cli $out/bin/brev
  '';

  meta = with lib; {
    description = "Connect your laptop to cloud computers";
    homepage = "https://github.com/brevdev/brev-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
