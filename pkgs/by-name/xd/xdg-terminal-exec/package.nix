{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  dash,
  scdoc,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xdg-terminal-exec";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "Vladimir-csp";
    repo = "xdg-terminal-exec";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vFADl/SRxlHxq75TgQxpHX8b9U1SptFHCFoOL9xzZpw=";
  };

  nativeBuildInputs = [ scdoc ];

  buildPhase = ''
    runHook preBuild
    scdoc < xdg-terminal-exec.1.scd > xdg-terminal-exec.1
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm555 xdg-terminal-exec -t $out/bin
    install -Dm444 xdg-terminal-exec.1 -t $out/share/man/man1
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
