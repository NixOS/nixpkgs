{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zeekstd";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "rorosen";
    repo = "zeekstd";
    tag = "v${finalAttrs.version}-cli";
    hash = "sha256-aht+QUprnSdBxJajBPgzqWzzOpkyrtzvJ98nqYKDCdc=";
  };

  cargoHash = "sha256-GEWCR4EaNQkB9mYxcWjlqSt75ko68RIU/10M4+zB+to=";

  meta = {
    description = "CLI tool that works with the zstd seekable format";
    homepage = "https://github.com/rorosen/zeekstd";
    changelog = "https://github.com/rorosen/zeekstd/releases/tag/v${finalAttrs.version}-cli";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.rorosen ];
    mainProgram = "zeekstd";
  };
})
