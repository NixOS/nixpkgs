{
  lib,
  stdenv,
  fetchFromGitea,
  installShellFiles,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zig-shell-completions";
  version = "0-unstable-2025-11-25";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ziglang";
    repo = "shell-completions";
    rev = "c2983a75dcbcaf3a1df74ab563a9bd3c8e7f448e";
    hash = "sha256-+sV3BitKhALNQys3u+wsMSHTH3QxoRZ1i75fazIgOjQ=";
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
    homepage = "https://codeberg.org/ziglang/shell-completions";
    description = "Shell completions for the Zig compiler";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aaronjheng ];
    platforms = lib.platforms.all;
  };
})
