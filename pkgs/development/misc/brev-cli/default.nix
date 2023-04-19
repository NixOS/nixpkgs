{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "brev-cli";
  version = "0.6.217";

  src = fetchFromGitHub {
    owner = "brevdev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wrdR0g8lND0V7BCKXDyk93Kf7eEIdg4Vb85MbhhK8AE=";
  };

  vendorHash = "sha256-IR/tgqh8rS4uN5jSOcopCutbHCKHSU9icUfRhOgu4t8=";

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
