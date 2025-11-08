{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "yatto";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "handlebargh";
    repo = "yatto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZIGtRPy2DfMzCK0WHJcv75d2oeHd2Sh3twrV6G/m5SI=";
  };

  vendorHash = "sha256-e+xv1mr8F3ODSsk67shJ+vI3isWcN3vaaqElUoDnvs0=";

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
