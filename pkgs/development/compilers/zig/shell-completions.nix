{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, unstableGitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zig-shell-completions";
  version = "0-unstable-2023-11-18";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = "shell-completions";
    rev = "31d3ad12890371bf467ef7143f5c2f31cfa7b7c1";
    hash = "sha256-ID/K0vdg7BTKGgozISk/X4RBxCVfhSkVD6GSZUoP9Ls=";
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
