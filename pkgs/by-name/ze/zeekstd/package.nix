{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zeekstd";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "rorosen";
    repo = "zeekstd";
    tag = "v${finalAttrs.version}-cli";
    hash = "sha256-9sUo3RptvCtxmtV49+X09TrOH2t+zB/PCYmeYLWNeGU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ggEXjfv4PxVfD7poeFXeACMIMh0A7ar2sm2epY5TO1Y=";

  meta = {
    description = "CLI tool that works with the zstd seekable format";
    homepage = "https://github.com/rorosen/zeekstd";
    changelog = "https://github.com/rorosen/zeekstd/releases/tag/v${finalAttrs.version}-cli";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.rorosen ];
    mainProgram = "zeekstd";
  };
})
