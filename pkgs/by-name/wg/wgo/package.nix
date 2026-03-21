{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "wgo";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "bokwoon95";
    repo = "wgo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J2mS2GIGlNHQVCIVpOMxZIZiqOFW0fu0M+qAbEuOuRo=";
  };

  vendorHash = "sha256-6ZJNXw/ahaIziQGVNgjbTbm53JiO3dYCqJtdB///cmo=";

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
