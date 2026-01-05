{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  pname = "wgo";
  version = "0.6.2";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "bokwoon95";
    repo = "wgo";
    rev = "v${version}";
    hash = "sha256-Z3adi1PQ5v0BxcjkOJZWeUxwLlLXpNuJxrQztV2pCiA=";
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

  meta = with lib; {
    description = "Live reload for Go apps";
    mainProgram = "wgo";
    homepage = "https://github.com/bokwoon95/wgo";
    license = licenses.mit;
    maintainers = [ ];
  };
}
