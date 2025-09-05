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
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "timewarrior";
    tag = "v${version}";
    hash = "sha256-wwuyXcLCrNvpDIQvoBt/OQlwoTMhPzGZ+WrZdTo6IPo=";
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
