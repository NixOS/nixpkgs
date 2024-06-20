{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  ...
}:

buildGoModule rec {
  pname = "workout-tracker";
  version = "1.15.2";

  src = fetchFromGitHub {
    owner = "jovandeginste";
    repo = "workout-tracker";
    rev = "refs/tags/v${version}";
    hash = "sha256-NYRoIfhdOjyC9WPp3hsHFZWpAsDjbMk2vLn79PixhvE=";
  };

  vendorHash = null;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/jovandeginste/workout-tracker/releases/tag/v${version}";
    description = "Workout tracking web application for personal use";
    homepage = "https://github.com/jovandeginste/workout-tracker";
    license = lib.licenses.mit;
    mainProgram = "workout-tracker";
    maintainers = with lib.maintainers; [ bhankas ];
  };
}
