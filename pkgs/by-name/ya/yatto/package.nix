{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "yatto";
  version = "0.21.6";

  src = fetchFromGitHub {
    owner = "handlebargh";
    repo = "yatto";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t1fPLlpe950IsBcpUj5MLhG/sNOsZOkM/Bw6lrmL3cY=";
  };

  vendorHash = "sha256-I/9Wcwm2rnQxixevtz1i3fhmlM0b8Yq4pb2eieG7bq0=";

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
