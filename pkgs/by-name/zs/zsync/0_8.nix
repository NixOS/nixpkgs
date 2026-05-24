{
  lib,
  buildGoModule,
  fetchFromGitHub,

  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "zsync";
  version = "0.8.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cph6";
    repo = "zsync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GZxk0W91CYEi4fdZpzi0vkhexB69Siuk94IGfl/WpP4=";
  };

  vendorHash = "sha256-CBQpkUb9T5Q1BFMdtKnils6/hidVFT5/MguQu60wnQ4=";

  subPackages = [
    "cmd/*"
    "internal/*"
  ];

  passthru.tests = nixosTests.zsync;

  meta = {
    description = "File distribution system using the rsync algorithm";
    homepage = "https://github.com/cph6/zsync";
    changelog = "https://github.com/cph6/zsync/raw/refs/tags/${finalAttrs.src.tag}/NEWS";
    license = lib.licenses.artistic2;
    maintainers = with lib.maintainers; [
      viric
      ryand56
    ];
    platforms = with lib.platforms; all;
    mainProgram = "zsync";
  };
})
