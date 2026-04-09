{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vivid";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "vivid";
    rev = "v${finalAttrs.version}";
    hash = "sha256-963rJz0ZsWnKQx8tO1Y65RHAW/oZnF4A5XKneP0PyBM=";
  };

  cargoHash = "sha256-oP5/G/PSkwn4JruLQOGtM8M2uPt4Q88bU3kNmXUK4JE=";

  meta = {
    description = "Generator for LS_COLORS with support for multiple color themes";
    homepage = "https://github.com/sharkdp/vivid";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "vivid";
  };
})
