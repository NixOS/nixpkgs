{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ttt";
  version = "1.8.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "eugenioenko";
    repo = "ttt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ousuIOWk3TRvPB3cilTXHhhAia0Hn+MUykr7uotA7f8=";
  };

  vendorHash = "sha256-DUyYhsMzjyhW2vtMRkSUKVBvcgJYZi5iUNVKw48l3+Q=";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/ttt" ];

  meta = {
    description = "IDE that lives in your terminal";
    homepage = "http://tttedit.dev";
    downloadPage = "https://github.com/eugenioenko/ttt";
    changelog = "https://github.com/eugenioenko/ttt/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "ttt";
  };
})
