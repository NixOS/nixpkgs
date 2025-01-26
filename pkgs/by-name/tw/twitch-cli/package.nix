{
  buildGoModule,
  fetchFromGitHub,
  lib,
  testers,
  twitch-cli,
}:

buildGoModule rec {
  pname = "twitch-cli";
  version = "1.1.24";

  src = fetchFromGitHub {
    owner = "twitchdev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kRyJl2SxppVGCO/6wrsb8cO+wpBT1nBsyI/JsPRYzMc=";
  };

  patches = [
    ./application-name.patch
  ];

  vendorHash = "sha256-Z5bWS4oqjkEfOsvBzupKKnF6rJPU0TLVdwxDkIKcBQY=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.buildVersion=${version}"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  __darwinAllowLocalNetworking = true;

  passthru.tests.version = testers.testVersion {
    package = twitch-cli;
    command = "HOME=$(mktemp -d) ${pname} version";
    version = "${pname}/${version}";
  };

  meta = with lib; {
    description = "Official Twitch CLI to make developing on Twitch easier";
    mainProgram = "twitch-cli";
    homepage = "https://github.com/twitchdev/twitch-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ benediktbroich ];
  };
}
