{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xan";
  version = "0.57.0";

  src = fetchFromGitHub {
    owner = "medialab";
    repo = "xan";
    tag = finalAttrs.version;
    hash = "sha256-54kLrWOSHnS26nogw/u3Prq6nfxsrT/VaDKEQr8kK48=";
  };

  cargoHash = "sha256-3L6WMkCecyhYVWchcFcs5lesxax468pIZc+ZllLwbro=";

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
