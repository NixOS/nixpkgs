{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, unstableGitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zig-shell-completions";
  version = "unstable-2023-08-17";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = "shell-completions";
    rev = "de9f83166d792cce6a0524e63d2755952dd9872c";
    hash = "sha256-92n41/AWbHYkXiBtbWw+hXZKJCE7KW9igd8cLSBQfHo=";
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
