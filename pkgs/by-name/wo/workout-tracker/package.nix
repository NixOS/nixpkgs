{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  ...
}:

buildGoModule rec {
  pname = "workout-tracker";
  version = "0.13.4";

  src = fetchFromGitHub {
    owner = "jovandeginste";
    repo = "workout-tracker";
    rev = "refs/tags/v${version}";
    hash = "sha256-wBDLf4UfE3YXH2naub9Z//z5HWaTBuz6MyCQovZcsFI=";
  };

  vendorHash = null;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/jovandeginste/workout-tracker/releases/tag/v${version}";
    description = "A workout tracking web application for personal use";
    homepage = "https://github.com/jovandeginste/workout-tracker";
    license = lib.licenses.mit;
    mainProgram = "workout-tracker";
    maintainers = with lib.maintainers; [ bhankas ];
  };
}
