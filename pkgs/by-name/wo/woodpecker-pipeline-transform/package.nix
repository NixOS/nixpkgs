{
  lib,
  buildGoModule,
  fetchFromCodeberg,
}:
buildGoModule (finalAttrs: {
  pname = "woodpecker-pipeline-transform";
  version = "0.3.0";

  src = fetchFromCodeberg {
    owner = "lafriks";
    repo = "woodpecker-pipeline-transform";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5bdNtVjk7TBoS0Z026th674ZXCRRc3DbtVOLl+acKhQ=";
  };

  vendorHash = "sha256-4JRSrkxH8/NlSwUk6KagC5+mx+UXSLvo1thSRciAewc=";

  meta = {
    description = "Utility to convert different pipelines to Woodpecker CI pipelines";
    changelog = "https://codeberg.org/lafriks/woodpecker-pipeline-transform/src/tag/v${finalAttrs.version}";
    homepage = "https://codeberg.org/lafriks/woodpecker-pipeline-transform";
    license = lib.licenses.mit;
    mainProgram = "pipeline-convert";
    maintainers = with lib.maintainers; [
      ambroisie
      luftmensch-luftmensch
    ];
  };
})
