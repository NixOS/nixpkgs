{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  asciidoctor,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "timewarrior";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "timewarrior";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kJdPnjQ2ZXLx5/o6CmKnlrxadhYMpQlbkJv8tHUVcCM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    asciidoctor
    installShellFiles
  ];

  dontUseCmakeBuildDir = true;

  postInstall = ''
    installShellCompletion --cmd timew \
      --bash completion/timew-completion.bash \
      --fish completion/timew.fish \
      --zsh completion/timew.zsh
  '';

  meta = {
    description = "Command-line time tracker";
    homepage = "https://timewarrior.net";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      mrVanDalo
    ];
    mainProgram = "timew";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
