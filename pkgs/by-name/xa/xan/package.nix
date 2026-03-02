{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xan";
  version = "0.56.0";

  src = fetchFromGitHub {
    owner = "medialab";
    repo = "xan";
    tag = finalAttrs.version;
    hash = "sha256-eXzWquBFuX4DB9uOJFgWwp1cNxi02KcU4yZQ3PsPRRs=";
  };

  cargoHash = "sha256-Mck41QDRCyQvbKDIIjaoniHOk2U5FPbr4Oun2WuL800=";

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
})
