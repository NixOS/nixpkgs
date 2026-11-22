{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "walk";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "walk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-37ZXLOaTzX9bQXhzyyohL6mtmGLOgi/LRjK2Ry0ZtEY=";
  };

  vendorHash = "sha256-a66vA6eFzckxBpVtHaX0PBtulTBPbh7c6HY3dIZAym8=";

  meta = {
    description = "Terminal file manager";
    homepage = "https://github.com/antonmedv/walk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      portothree
      surfaceflinger
    ];
    mainProgram = "walk";
  };
})
