{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zet";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "yarrow";
    repo = "zet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WnB2kxfWdWZCRqlSUL0cV4l9dIUr+cm7QCXF6F1ktt0=";
  };

  cargoHash = "sha256-EIj2BUVS1tbY+kxUnpu1C+0+n68gTFZbp45f5UNidtY=";

  # tests fail with `--release`
  # https://github.com/yarrow/zet/pull/7
  checkType = "debug";

  meta = {
    description = "CLI utility to find the union, intersection, set difference, etc of files considered as sets of lines";
    mainProgram = "zet";
    homepage = "https://github.com/yarrow/zet";
    changelog = "https://github.com/yarrow/zet/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ figsoda ];
  };
})
