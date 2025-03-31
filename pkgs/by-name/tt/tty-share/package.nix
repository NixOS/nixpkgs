{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tty-share";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "elisescu";
    repo = "tty-share";
    rev = "v${version}";
    sha256 = "sha256-+Bh39WtzReOmHcvpGbNfEdBqw7ZL9Vhxu5d337CMc/M=";
  };

  # Upstream has a `./vendor` directory with all deps which we rely upon.
  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    homepage = "https://tty-share.com";
    description = "Share terminal via browser for remote work or shared sessions";
    license = licenses.mit;
    maintainers = with maintainers; [ andys8 ];
    mainProgram = "tty-share";
  };
}
