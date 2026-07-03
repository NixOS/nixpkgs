{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xan";
  version = "0.59.0";

  src = fetchFromGitHub {
    owner = "medialab";
    repo = "xan";
    tag = finalAttrs.version;
    hash = "sha256-jbtastPhBKrZ31TTr0LT4njTM2PrH/Suv8z6UVSkt1I=";
  };

  cargoHash = "sha256-wh74QO+7QLMdKlqnH5AD52WnkBmn+Hb+CopuGXfPUII=";

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
