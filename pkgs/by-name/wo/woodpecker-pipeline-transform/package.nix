{
  lib,
  buildGoModule,
  fetchFromCodeberg,
}:
buildGoModule (finalAttrs: {
  pname = "woodpecker-pipeline-transform";
  version = "1.0.0";

  src = fetchFromCodeberg {
    owner = "lafriks";
    repo = "woodpecker-pipeline-transform";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UXQ+b3SI+MO0T993hslQaRVMdHdPt9RnjyhfmLtooAU=";
  };

  vendorHash = "sha256-NE4KUbYA19YJPQW9quSYgm0exj3lToj9Zkiv05TgyOI=";

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
