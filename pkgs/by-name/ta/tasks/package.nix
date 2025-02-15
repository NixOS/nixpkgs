{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  just,
  libsecret,
  openssl,
  sqlite,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "tasks";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "tasks";
    tag = version;
    hash = "sha256-0bXzeKnJ5MIl7vCo+7kyXm3L6QrCdm5sPreca1SPi8U=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-9H4xzjgFpUsY5d6IpFt744058tVvMK0YHYvbnMWxNm8=";

  # COSMIC applications now uses vergen for the About page
  # Update the COMMIT_DATE to match when the commit was made
  env.VERGEN_GIT_COMMIT_DATE = "2024-07-03";
  env.VERGEN_GIT_SHA = "0e8c728c88a9cac1bac130eb083ca0fe58c7121d";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  buildInputs = [
    libsecret
    openssl
    sqlite
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/tasks"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/cosmic-utils/tasks/releases/tag/${version}";
    description = "Simple task management application for the COSMIC desktop";
    homepage = "https://github.com/cosmic-utils/tasks";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
    mainProgram = "tasks";
  };
}
