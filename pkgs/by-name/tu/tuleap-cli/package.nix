{
  lib,
  buildGoModule,
  fetchFromGitLab,
  installShellFiles,
}:

buildGoModule rec {
  pname = "tuleap-cli";
  version = "1.1.0";

  src = fetchFromGitLab {
    owner = "csgroup-oss";
    repo = "tuleap-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-hL0mGWXzvHYFc8u4RXCDys3Fe/cgsGljfhSkPAjzt4o=";
  };

  vendorHash = "sha256-N9Hmxw/70Cgc790AVRn7lmuhMtDhI94CTUlqHU4VbaY=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

  subPackages = [ "." ];

  postInstall = ''
    installShellCompletion --cmd tuleap-cli \
      --bash <($out/bin/tuleap-cli -s tuleap.example.com completion bash) \
      --fish <($out/bin/tuleap-cli -s tuleap.example.com completion fish) \
      --zsh <($out/bin/tuleap-cli -s tuleap.example.com completion zsh)
  '';

  meta = {
    description = "Command-line interface for the Tuleap API";
    homepage = "https://gitlab.com/csgroup-oss/tuleap-cli";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ lesuisse ];
    mainProgram = "tuleap-cli";
  };
}
