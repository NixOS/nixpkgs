{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "brev-cli";
  version = "0.6.102";

  src = fetchFromGitHub {
    owner = "brevdev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QXYcLy8k1s2/kVwgnMnsJemkewCQzm8NJq7GcBD06vE=";
  };

  vendorSha256 = "sha256-5P9oodntXn7RMpjKLoCXlnEZeW4/W0hfYPt7I3hjvGw=";

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
