{ lib
, buildGoModule
, fetchFromGitLab
, installShellFiles
}:

buildGoModule rec {
  pname = "tuleap-cli";
  version = "1.0.0";

  src = fetchFromGitLab {
    owner = "csgroup-oss";
    repo = "tuleap-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZNAMhKszly2C+ljFGbP8xqUplQaxqaoArRJykuPNrkY=";
  };

  vendorHash = "sha256-T5GA9IqH3PPQV2b0uJq2O4Nzu82Q5y/LgKAVJV/XqC4=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

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
