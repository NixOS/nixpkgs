{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yesser-todo-cli";
  version = "1.4.0";
  __structuredAttrs = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  src = fetchFromGitHub {
    owner = "yesser-studios";
    repo = "yesser-todo-cli";
    tag = "yesser-todo-cli-v${finalAttrs.version}";
    hash = "sha256-e1Zstezojdk9FibY0kH58+LybdNrjIfp3gfIqWkAlK0=";
  };

  cargoHash = "sha256-4pA9oilXItjU8Wmwwd5lV+dXKMOt9RywGxpqGu3G4OU=";

  cargoTestFlags = [
    "--package"
    "yesser-todo-cli"
  ];
  cargoBuildFlags = [
    "--package"
    "yesser-todo-cli"
  ];

  meta = {
    description = "CLI app for managing your tasks";
    homepage = "https://github.com/yesser-studios/yesser-todo-cli";
    changelog = "https://github.com/yesser-studios/yesser-todo-cli/releases/tag/yesser-todo-cli-v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      yesseruser
    ];
    mainProgram = "todo";
  };
})
