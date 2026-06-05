{
  alsa-lib,
  dbus,
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  gitMinimal,
  rustPlatform,
  writeShellScript,
  curl,
  jq,
  gnused,
  nix-update,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ytermusic";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "ccgauche";
    repo = "ytermusic";
    tag = "beta-${finalAttrs.version}";
    hash = "sha256-eZoh3eZL9x5ni5eSHwatCinGcBqFRd0GOBSz+9CjvhE=";
  };

  cargoHash = "sha256-GyFny1V7Cl/ktKvyNbdWyX90m3P/bZ5/tZz7uZISV+s=";

  # need network
  doCheck = false;

  cargoBuildType = "release";

  nativeBuildInputs = [
    gitMinimal
    pkg-config
  ];

  buildInputs = [
    openssl
    alsa-lib
    dbus
  ];

  passthru.updateScript = writeShellScript "update-script" ''
    latestVersion=$(${lib.getExe curl} ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} --fail --silent https://api.github.com/repos/ccgauche/ytermusic/tags | ${lib.getExe jq} --raw-output '.[0].name' | ${lib.getExe gnused} -E 's/beta-//')
    ${lib.getExe nix-update} $UPDATE_NIX_ATTR_PATH --version $latestVersion
  '';

  meta = {
    description = "TUI based Youtube Music Player that aims to be as fast and simple as possible";
    homepage = "https://github.com/ccgauche/ytermusic";
    changelog = "https://github.com/ccgauche/ytermusic/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ codebam ];
    mainProgram = "ytermusic";
  };
})
