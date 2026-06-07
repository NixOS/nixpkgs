{
  lib,
  python3Packages,
  fetchFromGitHub,
  ffmpeg,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "terminal-rain-lightning";
  version = "0-unstable-2026-04-30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rmaake1";
    repo = "terminal-rain-lightning";
    rev = "cc3aa19e1e9aec628a608b0ca6b7c475cce98c05";
    hash = "sha256-GJvGnvo78l4RK2Y9ACbqOXHLQkNtIwIktbm/FK1vOcc=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  preFixup = ''
    makeWrapperArgs+=("--prefix" "PATH" ":" "${lib.makeBinPath [ ffmpeg ]}")
  '';

  __structuredAttrs = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based ASCII rain and lightning animation";
    homepage = "https://github.com/rmaake1/terminal-rain-lightning";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nicolas-goudry ];
    mainProgram = "terminal-rain";
  };
})
