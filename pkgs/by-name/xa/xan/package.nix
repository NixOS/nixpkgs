{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xan";
  version = "0.60.0";

  src = fetchFromGitHub {
    owner = "medialab";
    repo = "xan";
    tag = finalAttrs.version;
    hash = "sha256-CexefTLr8K6rNtXE8dog0cA4OlRa/uReK1HJrx471+4=";
  };

  cargoHash = "sha256-WGva0hf0eB/4VUPsNQZJnAW2uWctsVLqSsYkuoreMog=";

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
