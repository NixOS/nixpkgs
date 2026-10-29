{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wgo";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "bokwoon95";
    repo = "wgo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2pDqSEeawPRU3+1Jr+Ph0ix8ooEZhfsEb5jL6W4+7k4=";
  };

  vendorHash = "sha256-c7Cp08kmDOV63tvfSkGcO+SWgpuzJEm/vqbCVPS/v/Q=";

  ldflags = [
    "-s"
    "-w"
  ];

  subPackages = [ "." ];

  checkFlags = [
    # Flaky tests.
    # See https://github.com/bokwoon95/wgo/blob/e0448e04b6ca44323f507d1aca94425b7c69803c/START_HERE.md?plain=1#L26.
    "-skip=TestWgoCmd_FileEvent"
  ];

  meta = {
    description = "Live reload for Go apps";
    mainProgram = "wgo";
    homepage = "https://github.com/bokwoon95/wgo";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
