{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zig-shell-completions";
  version = "0-unstable-2025-06-29";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = "shell-completions";
    rev = "4f91bcbe28cec28ff707d5e032333cbdbfa01161";
    hash = "sha256-4uzM5pFnYf5dTkw3igzWUCYYsBZVTrb/mFf5iHFiGT4=";
  };

  nativeBuildInputs = [ installShellFiles ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    installShellCompletion --bash --name zig.bash _zig.bash
    installShellCompletion --zsh --name _zig _zig

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/ziglang/shell-completions";
    description = "Shell completions for the Zig compiler";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aaronjheng ];
    platforms = lib.platforms.all;
  };
})
