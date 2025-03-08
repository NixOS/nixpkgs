{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:
let
  version = "0.2.2";
in
rustPlatform.buildRustPackage {
  pname = "zeekstd";
  inherit version;

  src = fetchFromGitHub {
    owner = "rorosen";
    repo = "zeekstd";
    tag = "v${version}";
    hash = "sha256-Blyp5GpnytB3S4k6lp2fAwXueaUtXqPW+WLEmFNPZc0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-bbl0zHxd2HYkctX029mtxDciC2tnPVTlHxYyetmtuw0=";
  stripAllList = [ "bin" ];

  meta = {
    description = "CLI tool that works with the zstd seekable format";
    homepage = "https://github.com/rorosen/zeekstd";
    changelog = "https://github.com/rorosen/zeekstd/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.rorosen ];
    mainProgram = "zeekstd";
  };
}
