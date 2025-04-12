{
  buildGoModule,
  fetchFromGitHub,
  lib,
  testers,
  twitch-cli,
}:

buildGoModule rec {
  pname = "twitch-cli";
  version = "1.1.25";

  src = fetchFromGitHub {
    owner = "twitchdev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+6/o2vhj1iaT0hkyQRedn7ga1dhNZOupX4lOadnTDU0=";
  };

  patches = [
    ./application-name.patch
  ];

  vendorHash = "sha256-LPpUnielSeGE0k68z+M565IqXQUIkAh5xloOqcbfh20=";

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
