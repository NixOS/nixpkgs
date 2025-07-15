{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  asciidoctor,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "timewarrior";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "timewarrior";
    rev = "v${version}";
    hash = "sha256-6WZ5k9cxWe+eS9me700ITq0rKEiIuDhTtmuzhOnUM4k=";
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

  meta = with lib; {
    description = "Command-line time tracker";
    homepage = "https://timewarrior.net";
    license = licenses.mit;
    maintainers = with maintainers; [
      matthiasbeyer
      mrVanDalo
    ];
    mainProgram = "timew";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
