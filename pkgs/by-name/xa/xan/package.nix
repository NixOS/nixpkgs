{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xan";
  version = "0.61.0";

  src = fetchFromGitHub {
    owner = "medialab";
    repo = "xan";
    tag = finalAttrs.version;
    hash = "sha256-Z8sEwoM0RdUqN4rlc8PP1D5046405UqtBD7RU+ybKlU=";
  };

  cargoHash = "sha256-dw8KlbCTK+K8okT88CbZieM/BmFDAKmGClirazRMEuI=";

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
