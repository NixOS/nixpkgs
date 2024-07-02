{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "wsl";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "bombsimon";
    repo = "wsl";
    rev = "v${version}";
    hash = "sha256-2vDLpqNEQCiWCu7M5ciek2mN/tVaJFzIGCVOFvwOc80=";
  };

  vendorHash = "sha256-b46aLbJ4CWC5OrNwMUncNf1oEfNtKQTIC8jEWptkc5k=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Whitespace Linter - Forces you to use empty lines";
    homepage = "https://github.com/bombsimon/wsl";
    license = licenses.mit;
    maintainers = with maintainers; [ meain ];
    mainProgram = "wsl";
  };
}
