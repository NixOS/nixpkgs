{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yesser-todo-server";
  version = "2.0.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "yesser-studios";
    repo = "yesser-todo-cli";
    tag = "yesser-todo-server-v${finalAttrs.version}";
    hash = "sha256-YRuTbVbKXNGkwdImrLfpEBH+ij6dK3n84Bm8fUw057I=";
  };

  cargoHash = "sha256-/EoB6aRUHNZKJeK/IwwzO8tzbrm5cnUCBHaO1gMv2cE=";

  cargoTestFlags = [
    "--package"
    "yesser-todo-server"
  ];
  cargoBuildFlags = [
    "--package"
    "yesser-todo-server"
  ];

  meta = {
    description = "Server for yesser-todo-cli";
    homepage = "https://github.com/yesser-studios/yesser-todo-cli";
    changelog = "https://github.com/yesser-studios/yesser-todo-cli/commits/yesser-todo-server-${finalAttrs.version}/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      yesseruser
    ];
    mainProgram = "yesser-todo-server";
  };
})
