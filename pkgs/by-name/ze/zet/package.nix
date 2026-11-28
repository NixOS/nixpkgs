{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zet";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "yarrow";
    repo = "zet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aJF9y354tem2b6qbZg8LSoRhnKDaUVfgt5z+NsRM2Ag=";
  };

  cargoHash = "sha256-qtQ71JLXCrkcOZ4fYA1FihwNJF8W5x21hRYmWEiwNps=";

  # tests fail with `--release`
  # https://github.com/yarrow/zet/pull/7
  checkType = "debug";

  env.RUSTFLAGS = "-Amismatched_lifetime_syntaxes";

  meta = {
    description = "CLI utility to find the union, intersection, set difference, etc of files considered as sets of lines";
    mainProgram = "zet";
    homepage = "https://github.com/yarrow/zet";
    changelog = "https://github.com/yarrow/zet/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = [ ];
  };
})
