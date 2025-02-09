{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "xdg-terminal-exec";
  version = "unstable-2023-12-08";

  src = fetchFromGitHub {
    owner = "Vladimir-csp";
    repo = "xdg-terminal-exec";
    rev = "04f37d4337b6ce157d4a7338dd600a32deb43a28";
    hash = "sha256-QIPdF+/dMUEVcz5j9o+wQ4dnw2yWwz7slnLdMNETkGs=";
  };

  dontBuild = true;
  installPhase = ''
    runHook preInstall
    install -Dm555 xdg-terminal-exec -t $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Proposal for XDG terminal execution utility";
    homepage = "https://github.com/Vladimir-csp/xdg-terminal-exec";
    license = lib.licenses.gpl3Plus;
    mainProgram = "xdg-terminal-exec";
    maintainers = with lib.maintainers; [quantenzitrone];
    platforms = lib.platforms.unix;
  };
}
