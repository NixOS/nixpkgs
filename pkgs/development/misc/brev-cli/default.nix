{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "brev-cli";
  version = "0.6.95";

  src = fetchFromGitHub {
    owner = "brevdev";
    repo = pname;
    rev = "v${version}";
    sha256 = "09qhc38ycqs6vdyy1rxaxbihq0q59g2ffkmmlk6ipdlv2b3ywz0f";
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
