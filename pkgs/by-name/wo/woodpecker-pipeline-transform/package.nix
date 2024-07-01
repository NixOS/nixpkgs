{
  lib,
  buildGoModule,
  fetchFromGitea,
}:
buildGoModule rec {
  pname = "woodpecker-pipeline-transform";
  version = "0.2.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "lafriks";
    repo = "woodpecker-pipeline-transform";
    rev = "v${version}";
    sha256 = "sha256-ngtpWjbL/ccmKTNQdL3osduELYSxcOu5z5UtqclNNSY=";
  };

  vendorHash = "sha256-SZxFsn187UWZqaxwMDdzAmfpRLZSCIpbsAI1mAu7Z6w=";

  meta = {
    description = "Utility to convert different pipelines to Woodpecker CI pipelines";
    changelog = "https://codeberg.org/lafriks/woodpecker-pipeline-transform/src/tag/v${version}";
    homepage = "https://codeberg.org/lafriks/woodpecker-pipeline-transform";
    license = lib.licenses.mit;
    mainProgram = "pipeline-convert";
    maintainers = with lib.maintainers; [
      ambroisie
      luftmensch-luftmensch
    ];
  };
}
