{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zig-shell-completions";
  version = "0-unstable-2024-07-08";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = "shell-completions";
    rev = "8d3db71e9a0497de98946b2ca2ee7e87d106607e";
    hash = "sha256-iil6M59S94f9SojTnwdWGOlIO/QOV77fJOUjyBa7jMk=";
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
