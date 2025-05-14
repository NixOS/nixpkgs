{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "termdbms";
  version = "unstable-2021-09-04";

  src = fetchFromGitHub {
    owner = "mathaou";
    repo = "termdbms";
    rev = "d46e72c796e8aee0def71b8e3499b0ebe5ca3385";
    hash = "sha256-+4y9JmLnu0xCJs1p1GNwqCx2xP6YvbIPb4zuClt8fbA=";
  };

  vendorHash = "sha256-RtgHus8k+6lvecG7+zABTo0go3kgoQj0S+3HaJHhKkE=";

  patches = [ ./viewer.patch ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/mathaou/termdbms/";
    description = "TUI for viewing and editing database files";
    license = licenses.mit;
    maintainers = with maintainers; [ izorkin ];
    mainProgram = "sqlite3-viewer";
  };
}
