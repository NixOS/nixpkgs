{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zeekstd";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "rorosen";
    repo = "zeekstd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Blyp5GpnytB3S4k6lp2fAwXueaUtXqPW+WLEmFNPZc0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-bbl0zHxd2HYkctX029mtxDciC2tnPVTlHxYyetmtuw0=";

  meta = {
    description = "CLI tool that works with the zstd seekable format";
    homepage = "https://github.com/rorosen/zeekstd";
    changelog = "https://github.com/rorosen/zeekstd/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.rorosen ];
    mainProgram = "zeekstd";
  };
})
