{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tetro-tui";
  version = "3.5.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Strophox";
    repo = "tetro-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9UHP3mo7sEjVPtBdLgbJpW3RlyXA8zAbY20CgBVdptg=";
  };

  cargoHash = "sha256-fBbHwCnlUuas+g1dFIRmOZM+hD32tp/++k1KNEFzphY=";

  meta = {
    description = "Terminal-based but modern tetromino-stacking game that is very customizable and cross-platform";
    homepage = "https://github.com/Strophox/tetro-tui";
    changelog = "https://github.com/Strophox/tetro-tui/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kybe236 ];
    mainProgram = "tetro-tui";
  };
})
