{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "urban-cli";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "tfkhdyt";
    repo = "urban-cli";
    rev = "v${version}";
    hash = "sha256-URTEhtOiwb3IDyjRUtUmVTaeDXw4Beg0woWdGxeq098=";
  };

  vendorHash = "sha256-fEZzX+ecSWKITXczcwm5BGw5OWuixa4XKrEx8z0pxXQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Blazingly fast command line interface for Urban Dictionary";
    homepage = "https://github.com/tfkhdyt/urban-cli";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ tfkhdyt ];
    mainProgram = "urban-cli";
  };
}
