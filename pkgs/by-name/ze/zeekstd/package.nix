{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zeekstd";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "rorosen";
    repo = "zeekstd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-URQ8UiCy8qnm0VM55BqPgIthR4AIyRk+fgowAFxvXwM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-lS4RQuwvY6bRpsev7RI3XWBPbrdek5im/rkzP+Cmgpc=";

  meta = {
    description = "CLI tool that works with the zstd seekable format";
    homepage = "https://github.com/rorosen/zeekstd";
    changelog = "https://github.com/rorosen/zeekstd/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.rorosen ];
    mainProgram = "zeekstd";
  };
})
