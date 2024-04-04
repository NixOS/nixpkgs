{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  ...
}:

buildGoModule rec {
  pname = "workout-tracker";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "jovandeginste";
    repo = "workout-tracker";
    rev = "refs/tags/v${version}";
    hash = "sha256-ekGaNHysY0lXbB5w6AycnLR9/4dqUp0busCcPPvzSVI=";
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
