{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "tcardgen";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "Ladicle";
    repo = "tcardgen";
    tag = "v${version}";
    hash = "sha256-q0w1NAE+Du1CbdmiAQ5oP4GOLvqI5hUboRUdYWl9vN8=";
  };

  vendorHash = "sha256-X39L1jDlgdwMALzsVIUBocqxvamrb+M5FZkDCkI5XCc=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "TwitterCard(OGP) image generator for Hugo posts";
    homepage = "https://github.com/Ladicle/tcardgen";
    license = lib.licenses.mit;
    mainProgram = "tcardgen";
    maintainers = with lib.maintainers; [ nanamiiiii ];
  };
}
