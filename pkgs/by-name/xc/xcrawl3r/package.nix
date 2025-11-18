{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "xcrawl3r";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "hueristiq";
    repo = "xcrawl3r";
    tag = version;
    hash = "sha256-alrsEJZ7lyf7emYfJArn4VOnmLQFbWxL2eslEw+v4rY=";
  };

  vendorHash = "sha256-Ukz+fQuJp72Rhs/h+6kYp6rZgRFnAShO9+qGYuIjDh0=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "CLI utility to recursively crawl webpages";
    homepage = "https://github.com/hueristiq/xcrawl3r";
    changelog = "https://github.com/hueristiq/xcrawl3r/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "xcrawl3r";
  };
}
