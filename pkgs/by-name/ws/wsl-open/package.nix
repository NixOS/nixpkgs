{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wsl-open";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "4U6U57";
    repo = "wsl-open";
    tag = "v${finalAttrs.version}";
    hash = "sha256-amqkDXdgIqGjRZMkltwco0UAI++G0RY/MxLXwtlxogE=";
  };

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    install -m0755 -D wsl-open.sh $out/bin/wsl-open
    installManPage wsl-open.1
  '';

  meta = {
    description = "Open files with xdg-open from Windows Subsystem for Linux (WSL) in Windows applications";
    homepage = "https://gitlab.com/4U6U57/wsl-open";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "wsl-open";
  };
})
