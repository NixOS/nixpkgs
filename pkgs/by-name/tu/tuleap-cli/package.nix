{
  lib,
  buildGoModule,
  fetchFromGitLab,
  installShellFiles,
  stdenv,
}:

buildGoModule rec {
  pname = "tuleap-cli";
  version = "1.2.0";

  src = fetchFromGitLab {
    owner = "csgroup-oss";
    repo = "tuleap-cli";
    tag = version;
    hash = "sha256-qiQnu167BIF+LzwahheBE0KwxFmRcahdU7quTpPtEEk=";
  };

  vendorHash = "sha256-cO7+wG4uAd9e6n/KWQPYepixNmXBbuBxagT82hcbcIo=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

  subPackages = [ "." ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
