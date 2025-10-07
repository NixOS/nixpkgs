{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "yatto";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "handlebargh";
    repo = "yatto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GI/Q9lI6SqIOSYi5shMKlgegS8WdlWSFsPs7WLCB6Qg=";
  };

  vendorHash = "sha256-BqOuZUtyA7a8imzj3Oj1SUZ4k3kNjDYWiPlQRG9I0m8=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Terminal-based to-do application built with Bubble Tea";
    homepage = "https://github.com/handlebargh/yatto";
    changelog = "https://github.com/handlebargh/yatto/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gwg313 ];
    mainProgram = "yatto";
  };
})
