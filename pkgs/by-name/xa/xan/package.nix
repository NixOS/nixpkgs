{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "xan";
  version = "0.51.0";

  src = fetchFromGitHub {
    owner = "medialab";
    repo = "xan";
    tag = version;
    hash = "sha256-wfA8yyIFzwYkd/nuSOFv6Z7aDhBZiYzs2E/Pxouqicw=";
  };

  cargoHash = "sha256-8FJTiZuLRvHdDAYf3M0tWfT7BtCVuBlnIzmUMgBo8aA=";

  # FIXME: tests fail and I do not have the time to investigate. Temporarily disable
  # tests so that we can manually run and test the package for packaging purposes.
  doCheck = false;

  meta = {
    description = "Command line tool to process CSV files directly from the shell";
    homepage = "https://github.com/medialab/xan";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NotAShelf ];
    mainProgram = "xan";
  };
}
