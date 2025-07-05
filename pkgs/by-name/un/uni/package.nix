{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "uni";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "arp242";
    repo = "uni";
    tag = "v${version}";
    hash = "sha256-LSmQtndWBc7wCYBnyaeDb4Le4PQPcSO8lTp+CSC2jbc=";
  };

  vendorHash = "sha256-4w5L5Zg0LJX2v4mqLLjAvEdh3Ad69MLa97SR6RY3fT4=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  meta = {
    homepage = "https://github.com/arp242/uni";
    description = "Query the Unicode database from the commandline, with good support for emojis";
    changelog = "https://github.com/arp242/uni/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chvp ];
    mainProgram = "uni";
  };
}
