{
  lib,
  buildGoModule,
  fetchFromCodeberg,
}:
buildGoModule (finalAttrs: {
  pname = "woodpecker-pipeline-transform";
  version = "0.2.0";

  src = fetchFromCodeberg {
    owner = "lafriks";
    repo = "woodpecker-pipeline-transform";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ngtpWjbL/ccmKTNQdL3osduELYSxcOu5z5UtqclNNSY=";
  };

  vendorHash = "sha256-SZxFsn187UWZqaxwMDdzAmfpRLZSCIpbsAI1mAu7Z6w=";

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
