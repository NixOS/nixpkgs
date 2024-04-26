{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  dash,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xdg-terminal-exec";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "Vladimir-csp";
    repo = "xdg-terminal-exec";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zFclT+WooEpwO8zXBXpeh4bbKvQwvm4HxNKYXdNRzSA=";
  };

  dontBuild = true;
  installPhase = ''
    runHook preInstall
    install -Dm555 xdg-terminal-exec -t $out/bin
    runHook postInstall
  '';

  dontPatchShebangs = true;
  postFixup = ''
    substituteInPlace $out/bin/xdg-terminal-exec \
      --replace-fail '#!/bin/sh' '#!${lib.getExe dash}'
  '';

  meta = {
    description = "Reference implementation of the proposed XDG Default Terminal Execution Specification";
    homepage = "https://github.com/Vladimir-csp/xdg-terminal-exec";
    license = lib.licenses.gpl3Plus;
    mainProgram = "xdg-terminal-exec";
    maintainers = with lib.maintainers; [ quantenzitrone ];
    platforms = lib.platforms.unix;
  };
})
